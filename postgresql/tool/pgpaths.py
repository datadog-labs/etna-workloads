"""File classification for PostgreSQL (scope: src/ minus src/test/; contrib out of scope)."""
import re

TEST_RES = [
    re.compile(r'^src/test/'),
    re.compile(r'(^|/)t/[^/]+\.(pl|pm)$'),           # TAP tests anywhere in src/
    re.compile(r'^src/pl/[^/]+/(src/)?(sql|expected|input|output|specs|data)/'),
    re.compile(r'^src/pl/plpython/.*/(sql|expected)/'),
    re.compile(r'^src/interfaces/ecpg/test/'),
    re.compile(r'^src/interfaces/libpq/test/'),
    re.compile(r'^src/bin/[^/]+/t/'),
    re.compile(r'^src/(backend|bin|common|interfaces)/.*/(sql|expected|specs)/[^/]+$'),
]
NON_IMPL_RES = [
    re.compile(r'(^|/)(GNU)?[Mm]akefile[^/]*$'),
    re.compile(r'(^|/)meson\.build$'),
    re.compile(r'(^|/)meson_options\.txt$'),
    re.compile(r'\.mk$'),
    re.compile(r'\.po$'), re.compile(r'(^|/)nls\.mk$'), re.compile(r'(^|/)po/'),
    re.compile(r'(^|/)README[^/]*$'), re.compile(r'\.gitignore$'), re.compile(r'\.gitattributes$'),
    re.compile(r'^src/tools/'), re.compile(r'^src/tutorial/'), re.compile(r'^src/makefiles/'),
    re.compile(r'^src/template/'), re.compile(r'\.(txt|sgml|html|md|rc|in|ico|png|svg|map|ac|m4|sample)$'),
    re.compile(r'^src/include/pg_config.*\.h\.in$'),
    re.compile(r'^src/(DEVELOPERS|Makefile.*|nls-global\.mk)$'),
    re.compile(r'\.abi-compliance-history$'),
    re.compile(r'^src/timezone/data/'),   # tz data is data, not code
    re.compile(r'^src/backend/(utils/mb/Unicode|snowball/libstemmer)/.*\.(txt|xml)$'),
]

def is_test(p):
    return p.startswith('src/') and any(r.search(p) for r in TEST_RES)

def is_impl(p):
    if not p.startswith('src/') or is_test(p):
        return False
    return not any(r.search(p) for r in NON_IMPL_RES)

def test_kind(p):
    if p.startswith('src/test/regress/'): return 'regress'
    if p.startswith('src/test/isolation/'): return 'isolation'
    if re.search(r'(^|/)t/[^/]+\.p[lm]$', p) or p.startswith('src/test/perl/'): return 'tap'
    if p.startswith('src/test/modules/'): return 'module'
    if p.startswith('src/pl/'): return 'pl'
    if p.startswith('src/interfaces/ecpg/test/'): return 'ecpg'
    return 'other'
