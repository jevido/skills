#!/usr/bin/env bash
# Detect whether a project uses yapyak (https://yapyak.dev) and report its wiring.
#
# Usage: detect-yapyak.sh [dir]      (default: cwd)
# Exit:  0 = uses yapyak   1 = partially wired   2 = not used   3 = no project found
#
# Read-only. Never writes, never installs.

set -uo pipefail

ROOT="${1:-$PWD}"
[ -d "$ROOT" ] || { echo "not a directory: $ROOT"; exit 3; }
ROOT="$(cd "$ROOT" && pwd)"

# --- locate package.json files (self, then up, then workspace children) -------
pkgs=()
d="$ROOT"
while [ "$d" != "/" ]; do
  [ -f "$d/package.json" ] && pkgs+=("$d/package.json")
  d="$(dirname "$d")"
done
while IFS= read -r p; do pkgs+=("$p"); done < <(
  find "$ROOT" -maxdepth 4 -name package.json \
    -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/dist/*' \
    -not -path '*/build/*' 2>/dev/null
)
# dedupe, keep order
if [ ${#pkgs[@]} -gt 0 ]; then
  mapfile -t pkgs < <(printf '%s\n' "${pkgs[@]}" | awk '!seen[$0]++')
fi

if [ ${#pkgs[@]} -eq 0 ]; then
  echo "yapyak: NOT_USED"
  echo "reason: no package.json found at or above $ROOT"
  echo "note: yapyak is a Vite-only JS/TS i18n tool. Non-JS project => not applicable."
  exit 2
fi

# --- yapyak packages declared? -----------------------------------------------
declared=""   # "pkgjson<TAB>name<TAB>range" lines
for p in "${pkgs[@]}"; do
  out=$(jq -r --arg p "$p" '
    [ (.dependencies // {}), (.devDependencies // {}), (.peerDependencies // {}), (.optionalDependencies // {}) ]
    | add // {}
    | to_entries
    | map(select(.key == "yapyak" or (.key | startswith("@yapyak/"))))
    | map($p + "\t" + .key + "\t" + .value)
    | .[]
  ' "$p" 2>/dev/null)
  [ -n "$out" ] && declared+="$out"$'\n'
done
declared="$(printf '%s' "$declared" | sed '/^$/d')"

# --- pick the app root: dir of the package.json that declares yapyak ---------
APP="$ROOT"
if [ -n "$declared" ]; then
  APP="$(dirname "$(printf '%s\n' "$declared" | head -1 | cut -f1)")"
fi

# --- config file --------------------------------------------------------------
CONFIG=""
for c in yapyak.config.ts yapyak.config.mts yapyak.config.mjs yapyak.config.js; do
  [ -f "$APP/$c" ] && { CONFIG="$APP/$c"; break; }
done

# --- bundler wiring -----------------------------------------------------------
plugin_files=""
while IFS= read -r f; do
  grep -qE "@yapyak/(vite|astro)|yapyak\(" "$f" 2>/dev/null && plugin_files+="$f"$'\n'
done < <(find "$APP" -maxdepth 3 \
  \( -name 'vite.config.*' -o -name 'astro.config.*' -o -name 'nuxt.config.*' \
     -o -name 'svelte.config.*' -o -name 'react-router.config.*' \) \
  -not -path '*/node_modules/*' 2>/dev/null)
plugin_files="$(printf '%s' "$plugin_files" | sed '/^$/d')"

# --- installed versions -------------------------------------------------------
installed=""
if [ -d "$APP/node_modules" ]; then
  while IFS= read -r m; do
    v=$(jq -r '.version // "?"' "$m/package.json" 2>/dev/null)
    installed+="$(basename "$(dirname "$m")" | sed 's/^@yapyak$/@yapyak/')/$(basename "$m") $v"$'\n'
  done < <(find "$APP/node_modules/@yapyak" -maxdepth 1 -mindepth 1 -type d 2>/dev/null)
  if [ -f "$APP/node_modules/yapyak/package.json" ]; then
    installed="yapyak $(jq -r '.version // "?"' "$APP/node_modules/yapyak/package.json")"$'\n'"$installed"
  fi
fi
installed="$(printf '%s' "$installed" | sed '/^$/d')"

# --- localesDir + locale files ------------------------------------------------
LOCALES_DIR="locales"
if [ -n "$CONFIG" ]; then
  d=$(grep -oE "localesDir:[[:space:]]*['\"][^'\"]+['\"]" "$CONFIG" 2>/dev/null | head -1 | sed -E "s/.*['\"]([^'\"]+)['\"].*/\1/")
  [ -n "$d" ] && LOCALES_DIR="$d"
fi
DEFAULT_LOCALE=""
if [ -n "$CONFIG" ]; then
  DEFAULT_LOCALE=$(grep -oE "defaultLocale:[[:space:]]*['\"][^'\"]+['\"]" "$CONFIG" 2>/dev/null | head -1 | sed -E "s/.*['\"]([^'\"]+)['\"].*/\1/")
fi
TRANSLATOR=""
if [ -n "$CONFIG" ]; then
  TRANSLATOR=$(grep -oE "@yapyak/(anthropic|openai|gemini|ollama|claude-code)" "$CONFIG" 2>/dev/null | head -1)
  [ -z "$TRANSLATOR" ] && grep -qE '^[[:space:]]*translator:' "$CONFIG" 2>/dev/null && TRANSLATOR="custom"
fi

locale_report=""
if [ -d "$APP/$LOCALES_DIR" ]; then
  while IFS= read -r lf; do
    stats=$(python3 - "$lf" <<'PY' 2>/dev/null
import json,sys
def walk(v):
    t=e=0
    if isinstance(v,str):
        return 1,(1 if v=="" else 0)
    if isinstance(v,dict):
        for x in v.values():
            a,b=walk(x); t+=a; e+=b
    return t,e
try:
    d=json.load(open(sys.argv[1]))
except Exception as ex:
    print("INVALID_JSON"); raise SystemExit
t,e=walk(d)
print(f"{t} {e} {len(d) if isinstance(d,dict) else 0}")
PY
)
    locale_report+="  $(basename "$lf"): ${stats:-unreadable}"$'\n'
  done < <(find "$APP/$LOCALES_DIR" -maxdepth 1 -name '*.json' 2>/dev/null | sort)
fi
locale_report="$(printf '%s' "$locale_report" | sed '/^$/d')"

# --- yapyak imports + t() call sites (only inside importing files) ------------
mapfile -t importers < <(grep -rIl "from 'yapyak'\|from \"yapyak\"\|from '@yapyak/\|from \"@yapyak/" "$APP" \
  --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' \
  --include='*.mts' --include='*.mjs' --include='*.vue' --include='*.svelte' --include='*.astro' \
  --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=.git 2>/dev/null \
  | grep -vE '/[^/]*\.config\.[a-z]+$')
IMPORTS=${#importers[@]}
TCALLS=0
if [ "$IMPORTS" -gt 0 ]; then
  TCALLS=$(grep -hoE "(^|[^A-Za-z0-9_.\$])t(\.(as|in))?\(['\"\`]" "${importers[@]}" 2>/dev/null | wc -l)
fi

# --- other i18n libraries (matters when yapyak is absent) ---------------------
OTHER_I18N=""
for p in "${pkgs[@]}"; do
  o=$(jq -r '
    [ (.dependencies // {}), (.devDependencies // {}) ] | add // {} | keys | .[]
    | select(test("i18n|intl|lingui|paraglide|inlang|translat"; "i"))
    | select(startswith("@yapyak/") or . == "yapyak" | not)
  ' "$p" 2>/dev/null)
  [ -n "$o" ] && OTHER_I18N+="$o"$'\n'
done
OTHER_I18N="$(printf '%s' "$OTHER_I18N" | sed '/^$/d' | sort -u)"

# --- verdict ------------------------------------------------------------------
has_dep=$([ -n "$declared" ] && echo 1 || echo 0)
has_cfg=$([ -n "$CONFIG" ] && echo 1 || echo 0)
has_plug=$([ -n "$plugin_files" ] && echo 1 || echo 0)

if [ "$has_dep" = 1 ] && [ "$has_cfg" = 1 ] && [ "$has_plug" = 1 ]; then
  verdict=USES; code=0
elif [ "$has_dep" = 1 ] || [ "$has_cfg" = 1 ] || [ "$has_plug" = 1 ]; then
  verdict=PARTIAL; code=1
else
  verdict=NOT_USED; code=2
fi

echo "yapyak: $verdict"
echo "app root: $APP"
echo
echo "signals:"
echo "  dependency declared : $([ "$has_dep" = 1 ] && echo yes || echo no)"
echo "  yapyak.config.*     : ${CONFIG:-none}"
echo "  bundler plugin      : $([ "$has_plug" = 1 ] && echo yes || echo no)"
echo "  yapyak imports      : $IMPORTS file(s)"
echo "  t() calls in them   : $TCALLS"
[ -n "$OTHER_I18N" ] && echo "  other i18n deps     : $(printf '%s' "$OTHER_I18N" | tr '\n' ' ')"

if [ -n "$declared" ]; then
  echo
  echo "declared packages:"
  printf '%s\n' "$declared" | awk -F'\t' '{print "  "$2" "$3}'
fi
if [ -n "$installed" ]; then
  echo
  echo "installed (node_modules):"
  printf '%s\n' "$installed" | sed 's/^/  /'
else
  [ "$has_dep" = 1 ] && { echo; echo "installed (node_modules): none — run the package manager install"; }
fi

if [ "$has_cfg" = 1 ]; then
  echo
  echo "config:"
  echo "  defaultLocale : ${DEFAULT_LOCALE:-en (default)}"
  echo "  localesDir    : $LOCALES_DIR"
  echo "  translator    : ${TRANSLATOR:-none (stubs stay empty)}"
fi

echo
if [ -n "$locale_report" ]; then
  echo "locale files in $LOCALES_DIR/ (entries empty-stubs source-files):"
  printf '%s\n' "$locale_report"
else
  echo "locale files in $LOCALES_DIR/: none"
fi

# --- translator package imported by config but not declared ------------------
MISSING_PKGS=""
if [ -n "$CONFIG" ]; then
  while IFS= read -r imp; do
    [ -z "$imp" ] && continue
    case "$imp" in
      @*) base="$(printf '%s' "$imp" | cut -d/ -f1-2)" ;;
      *)  base="$(printf '%s' "$imp" | cut -d/ -f1)" ;;
    esac
    printf '%s\n' "$declared" | cut -f2 | grep -qx "$base" || MISSING_PKGS+="$base"$'\n'
  done < <(grep -oE "from '(yapyak|@yapyak/[a-z-]+)(/[a-z-]+)?'" "$CONFIG" 2>/dev/null | sed -E "s/from '([^']+)'/\1/")
fi
MISSING_PKGS="$(printf '%s' "$MISSING_PKGS" | sed '/^$/d' | sort -u)"
if [ -n "$MISSING_PKGS" ]; then
  echo
  echo "imported by config but not in package.json:"
  printf '%s\n' "$MISSING_PKGS" | sed 's/^/  /'
fi

if [ "$verdict" = PARTIAL ]; then
  echo
  echo "gaps:"
  [ "$has_dep" = 0 ]  && echo "  - no yapyak package in any package.json"
  [ "$has_cfg" = 0 ]  && echo "  - no yapyak.config.* at $APP"
  [ "$has_plug" = 0 ] && echo "  - yapyak() not registered in vite/astro/nuxt config"
fi

exit $code
