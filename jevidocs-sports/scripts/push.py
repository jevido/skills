#!/usr/bin/env python3
"""Push <dir>/*.md to a jevidocs project (default `au`).

Run (one line):
  set -a && . ~/.config/jevidocs.env && set +a && python3 push.py <dir> [--project au] [--dry]
  python3 push.py --delete old/slug,other/slug [--dry]   # delete pages by slug
  python3 push.py --list > ../known-slugs.txt   # refresh the slug snapshot

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
B = f'https://api.jevidocs.jevido.app/api/admin/projects/{PROJECT}'
T = os.environ['token']
DRY = '--dry' in sys.argv
DIR = next((a for i, a in enumerate(args) if not a.startswith('--') and (i == 0 or args[i - 1] not in ('--project', '--delete'))), '.')


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
