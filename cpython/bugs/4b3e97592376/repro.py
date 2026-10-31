import argparse
for n in ("abc", 0):
    p = argparse.ArgumentParser()
    try:
        p.add_argument("--foo", nargs=n)
    except Exception as e:
        print(type(e).__name__, e)
    else:
        print("no error")
