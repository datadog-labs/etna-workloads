try:
    compile("[(c := 1) for a, (*b, c[d+e::f(g)], h.i) in j]", "<s>", "exec")
    print("compiled")
except SyntaxError as e:
    print("SyntaxError:", e.msg)
