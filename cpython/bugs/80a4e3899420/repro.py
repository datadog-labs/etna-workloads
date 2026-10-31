class customdict(dict):
    def __missing__(self, key):
        return key

ns = customdict()
exec(compile("type Alias = undefined", "test", "exec"), ns)
print(repr(ns["Alias"].__value__))

ns = customdict()
exec(compile("class A: type Alias = undefined", "test", "exec"), ns)
print(repr(ns["A"].Alias.__value__))
