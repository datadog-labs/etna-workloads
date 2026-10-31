it = iter(t"{1}")
print(type(next(it)).__name__)
for _ in range(2):
    try:
        next(it)
    except StopIteration:
        print("StopIteration")
