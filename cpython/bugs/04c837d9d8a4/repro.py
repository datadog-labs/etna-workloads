import itertools
code = (
    'class T:\n'
    '    def __init__(self):\n'
    '        self.{V1} = 10\n'
    '        self.{V2} = 10\n'
    '    def foo(self):\n'
    '        self.{V3} = 10\n'
)
for perm in itertools.permutations("abc"):
    ns = {}
    exec(code.format(V1=perm[0], V2=perm[1], V3=perm[2]), ns)
    print(perm, ns['T'].__static_attributes__)
