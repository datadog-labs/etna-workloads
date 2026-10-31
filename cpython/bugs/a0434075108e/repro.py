from collections import defaultdict

count = 0

def factory():
    global count
    count += 1
    n = count
    if n == 1:
        d["k"]
    return n

d = defaultdict(factory)
print(d["k"], count, dict(d))
