import argparse
for kw in ({'help': '    '}, {'choices': [], 'help': '%(choices)s'}):
    p = argparse.ArgumentParser(prog='PROG')
    p.add_argument('foo', **kw)
    try:
        print(repr(p.format_help()))
    except Exception as e:
        print(type(e).__name__, e)
