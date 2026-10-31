import argparse
p = argparse.ArgumentParser(exit_on_error=False)
p.add_argument('-k', '--known', action='count', default=0)
p.add_argument('-n', '--new', action='count', default=0)
for a in (['-k', '-u'], ['-u', '-k'], ['-ku'], ['-k=u'], ['-uk']):
    try:
        print(a, p.parse_known_args(a))
    except Exception as e:
        print(a, type(e).__name__, e)
