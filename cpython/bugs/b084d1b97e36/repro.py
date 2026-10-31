import argparse
p = argparse.ArgumentParser()
try:
    p.add_argument('--foo', const=True, action=argparse.BooleanOptionalAction)
    print("no error")
except TypeError as e:
    print("TypeError:", e)
