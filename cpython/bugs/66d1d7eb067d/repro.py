import types, unittest
loader = unittest.TestLoader()
print(repr(list(loader.loadTestsFromTestCase(unittest.FunctionTestCase))))
m = types.ModuleType('m')
m.TestCase = unittest.TestCase
m.FunctionTestCase = unittest.FunctionTestCase
print(repr(list(loader.loadTestsFromModule(m))))
