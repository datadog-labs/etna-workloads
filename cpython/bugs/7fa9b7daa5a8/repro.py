import bisect

def key(x):
    raise ValueError("boom")

for f in (bisect.insort, bisect.bisect_left):
    try:
        print(f([1, 2, 3], 2, key=key))
    except ValueError as e:
        print("ValueError", e)
