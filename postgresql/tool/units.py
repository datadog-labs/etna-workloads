"""Map PostgreSQL test files to runnable units and case ids.

A unit is (kind, dir, sel):
  ('pgr', dir, '')       -> `make -C dir check` with TAP disabled; cases are pg_regress test names
  ('tap', dir, 't/x.pl') -> `make -C dir check PROVE_TESTS=t/x.pl` with REGRESS/ISOLATION disabled
Case ids are '<dir>|<sel>|<name>'.
"""
import re, os

def _stem(name):
    name = re.sub(r'\.(sql|out|spec|source)$', '', name)
    return re.sub(r'_\d+$', '', name)          # alternative expected files: foo_1.out

def map_test_file(p):
    """Return (unit, case_name or None) for a test file path, or None if not runnable."""
    m = re.match(r'^(src/.+?)/(t/[^/]+\.pl)$', p)
    if m:
        return ('tap', m.group(1), m.group(2)), None        # all cases in the file
    m = re.match(r'^src/interfaces/ecpg/test/(?:expected/([a-z_]+)-([^/.]+)\.(?:c|stdout|stderr)|([a-z_]+)/([^/.]+)\.pgc)$', p)
    if m:
        sub, name = (m.group(1), m.group(2)) if m.group(1) else (m.group(3), m.group(4))
        return ('pgr', 'src/interfaces/ecpg', ''), f'{sub}/{name}'
    m = re.match(r'^(src/test/regress|src/test/isolation)/(sql|expected|specs|input|output)/([^/]+)$', p)
    if m:
        return ('pgr', m.group(1), ''), _stem(m.group(3))
    m = re.match(r'^(src/test/modules/[^/]+|src/pl/plpgsql/src|src/pl/plperl|src/pl/plpython|src/pl/tcl|src/test/[^/]+|src/bin/[^/]+)/(sql|expected|specs|input|output)/([^/]+)$', p)
    if m:
        return ('pgr', m.group(1), ''), _stem(m.group(3))
    return None

def case_id(unit, name):
    return f'{unit[1]}|{unit[2]}|{name}'

def unit_of_case(cid):
    d, sel, _ = cid.split('|', 2)
    return ('tap' if sel else 'pgr', d, sel)
