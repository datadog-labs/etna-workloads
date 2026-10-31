import encodings

for i in range(1500):
    try:
        b'x'.decode(f'nonexist_{i}')
    except LookupError:
        pass

print(len(encodings._cache) <= 500)
