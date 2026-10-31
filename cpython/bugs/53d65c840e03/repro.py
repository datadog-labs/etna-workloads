import io
import unittest

class SetUpClassFailure(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        raise Exception
    def testPass(self):
        pass

class Loader(unittest.TestLoader):
    def loadTestsFromModule(self, module, *args, **kw):
        return self.suiteClass([self.loadTestsFromTestCase(SetUpClassFailure)])

stream = io.StringIO()
try:
    unittest.main(argv=["x"], testRunner=unittest.TextTestRunner(stream=stream),
                  testLoader=Loader())
except SystemExit as e:
    print("exit code:", e.code)
