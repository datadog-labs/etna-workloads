code = """class Foo:
    def bar(self):
        [[(__x:=2) for _ in range(2)] for __x in range(2)]
"""
try:
    exec(code, {}, {})
    print("no error")
except SyntaxError as e:
    print("SyntaxError:", e.msg)
