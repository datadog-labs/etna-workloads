code = """
unique_name_1 = unique_name_5 = [1]
name_0 = 42
unique_name_7: {name_0 for name_0 in unique_name_1}
unique_name_2: {
    0: (lambda: name_0 for unique_name_4 in unique_name_5)
    for unique_name_6 in [1]
    if name_0
}
"""
ns = {"__name__": "m"}
exec(compile(code, "<test>", "exec"), ns)
annos = ns["__annotate__"](1)
print(sorted(annos))
print(annos["unique_name_7"])
print(list(annos["unique_name_2"][0])[0]())
