import pdb
with open("mod.py", "w") as f:
    f.write('def bar():\n    # comment\n    pass  # line 3\n')
print(pdb.find_function("bar", "mod.py"))
