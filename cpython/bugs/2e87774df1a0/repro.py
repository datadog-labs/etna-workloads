d = set(dir(list[int]))
print(d.issuperset(dir(list)))
for a in ("__origin__", "__args__", "__parameters__"):
    print(a, a in d)
