#!/usr/bin/env python3
"""Push <dir>/*.md to an AllUnited Docs project (default `au`).

Run (one line):
  set -a && . ~/.config/allunited-docs.env && set +a && python3 push.py <dir> [--project au] [--dry]
  python3 push.py --delete old/slug,other/slug [--dry]   # delete pages by slug
  python3 push.py --list > ../known-slugs.txt   # refresh the slug snapshot
  python3 push.py --menu [--nl]   # print the live sidebar: sections, positions, icons

Publishing needs an explicit <dir>, and refuses unknown flags and a <dir>
holding SKILL.md, so a typo never publishes the skill itself.

File name = slug with / as __ (tennis__club-year.md -> tennis/club-year).
A .nl.md suffix is the Dutch translation of the same slug
(tennis__club-year.nl.md), and _root.md is the home page (slug ''); a new translation copies position, icon, section and
root from the English page. --delete and --list take slug or nl:slug.
Front matter title/description/position/icon/section/root override; missing fields keep
the page's current values. Updates pages whose slug exists, creates the rest.
Deletes nothing.
"""
import glob, json, os, re, subprocess, sys

args = sys.argv[1:]
PROJECT = args[args.index('--project') + 1] if '--project' in args else 'au'
B = f'https://api.docs.allunited.dev/api/admin/projects/{PROJECT}'
T = os.environ['token']
DRY = '--dry' in sys.argv
DIR = next((a for i, a in enumerate(args) if not a.startswith('--') and (i == 0 or args[i - 1] not in ('--project', '--delete'))), None)
FLAGS = {'--project', '--dry', '--delete', '--list', '--menu', '--nl'}
bad = [a for a in args if a.startswith('--') and a not in FLAGS]
if bad:
    sys.exit(f'unknown flag {bad[0]}; known: {" ".join(sorted(FLAGS))}')


def call(method, url, data=None):
    args = ['curl', '-s', '-X', method, '-H', 'Authorization: Bearer ' + T,
            '-H', 'Content-Type: application/json']
    if data is not None:
        args += ['--data-binary', '@-']
    args.append(url)
    r = subprocess.run(args, input=json.dumps(data).encode() if data is not None else None,
                       capture_output=True)
    try:
        return json.loads(r.stdout)
    except Exception:
        return {'raw': r.stdout.decode()[:300]}


def parse(path):
    text = open(path).read()
    meta, body = {}, text
    m = re.match(r'^---\n(.*?)\n---\n', text, re.S)
    if m:
        body = text[m.end():]
        for line in m.group(1).splitlines():
            if ':' in line:
                k, v = line.split(':', 1)
                v = v.strip()
                if len(v) >= 2 and v[0] == v[-1] and v[0] in '"\'':
                    v = v[1:-1]
                meta[k.strip()] = v
    name = os.path.basename(path)[:-3]
    locale = ''
    if name.endswith('.nl'):
        name, locale = name[:-3], 'nl'
    if name == '_root':  # the project's home page, slug ''
        name = ''
    return name.replace('__', '/'), locale, meta, body.lstrip('\n')


def key(locale, slug):
    return f'{locale}:{slug}' if locale else slug


# English (locale '') and Dutch pages share slugs, so key them apart.
existing = {key(p.get('locale') or '', p['slug']): p for p in call('GET', f'{B}/pages')}
if '--delete' in args:
    for slug in args[args.index('--delete') + 1].split(','):
        cur = existing.get(slug)
        if not cur:
            print('NOT FOUND', slug)
        elif DRY:
            print('WOULD DELETE', slug, cur['id'])
        else:
            print('DELETE', slug, call('DELETE', f"{B}/pages/{cur['id']}"))
    sys.exit(0)
if '--list' in args:
    print('\n'.join(sorted(existing)))
    sys.exit(0)
if '--menu' in args:
    # The live sidebar: top-level pages in position order under their section
    # separator, each with its children. Root tabs (Classic, the sports) are
    # listed collapsed at the end; they are not the main documentation.
    loc = 'nl' if '--nl' in args else ''
    by = {p['slug']: p for p in existing.values() if (p.get('locale') or '') == loc}

    def parent(s):
        parts = s.split('/')
        for n in range(len(parts) - 1, 0, -1):
            if '/'.join(parts[:n]) in by:
                return '/'.join(parts[:n])
        return None

    kids = {}
    for p in by.values():
        kids.setdefault(parent(p['slug']) if p['slug'] else None, []).append(p)
    order = lambda p: (p.get('position', 50), p['slug'])

    def show(p, d):
        icon = f"  icon={p['icon']}" if p.get('icon') else ''
        print(f"{'  ' * d}{p.get('position', 50):>3}  {p['slug'] or '_root':<40} {p['title']}{icon}")
        for c in sorted(kids.get(p['slug'], []), key=order):
            show(c, d + 1)

    tops = sorted(kids.get(None, []), key=order)
    for sec in dict.fromkeys(p.get('section') or '' for p in tops if not p.get('root')):
        print(f"── {sec or '(no section)'}")
        for p in tops:
            if not p.get('root') and (p.get('section') or '') == sec:
                show(p, 1)
    print('── root tabs (not main documentation)')
    for p in tops:
        if p.get('root'):
            print(f"  {p.get('position', 50):>3}  {p['slug']:<40} {p['title']}  ({len(kids.get(p['slug'], []))} children)")
    sys.exit(0)
if DIR is None:
    sys.exit('give the directory to publish: push.py <dir> [--dry]')
if os.path.exists(os.path.join(DIR, 'SKILL.md')):
    sys.exit(f'{DIR} holds SKILL.md: that is the skill, not pages to publish')
for path in sorted(glob.glob(os.path.join(os.path.abspath(DIR), '*.md'))):
    slug, locale, meta, body = parse(path)
    cur = existing.get(key(locale, slug))
    # A new translation sits where its English page sits.
    src = cur or existing.get(slug) or {}
    d = {
        'slug': slug,
        'title': meta.get('title', cur['title'] if cur else slug),
        'description': meta.get('description', cur['description'] if cur else ''),
        'icon': meta.get('icon', src.get('icon', '')),
        'position': int(meta.get('position', src.get('position', 50))),
        'section': meta.get('section', src.get('section', '')),
        'published': True,
        'root': (meta.get('root', 'false') == 'true') or bool(src.get('root')),
        'locale': locale,
        'body': body,
    }
    if DRY:
        print('UPDATE' if cur else 'CREATE', key(locale, slug), d['position'], d['title'], len(body.split()), 'words')
        continue
    if cur:
        r = call('PUT', f"{B}/pages/{cur['id']}", d)
    else:
        r = call('POST', f'{B}/pages', d)
    print('UPDATE' if cur else 'CREATE', key(locale, slug), r.get('id', r))
