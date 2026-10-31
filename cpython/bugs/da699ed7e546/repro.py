import symtable
top = symtable.symtable("lambda x: x\n(i for i in y)", "?", "exec")
print([c.get_name() for c in top.get_children()])
