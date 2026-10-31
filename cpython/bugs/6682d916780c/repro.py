import symtable
st = symtable.symtable("(x for x in a)", "?", "exec")
c = st.get_children()[0]
print(repr(c.get_name()))
