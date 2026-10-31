import argparse, pickle
p = argparse.ArgumentParser(exit_on_error=False)
p.add_argument('--foo', type=int, default=42)
try:
    print(pickle.loads(pickle.dumps(p)).parse_args(['--foo', '123']))
except Exception as e:
    print(type(e).__name__, e)
