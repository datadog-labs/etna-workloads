import dis
src = "class C:\n  def __init__(self):\n    super().__init__()"
code = compile(src, "<test>", "exec").co_consts[0].co_consts
code = [c for c in code if hasattr(c, "co_code")][0]
for i in dis.get_instructions(code):
    if i.opname == "LOAD_GLOBAL":
        print(i.positions)
