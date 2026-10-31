import unittest, io

ordering = []

class InnerTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        ordering.append('inner setup')
        cls.addClassCleanup(ordering.append, 'inner cleanup')
    def test(self):
        ordering.append('inner test')

class OuterTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        ordering.append('outer setup')
        cls.addClassCleanup(ordering.append, 'outer cleanup')
    def test(self):
        ordering.append('start outer test')
        unittest.TextTestRunner(io.StringIO()).run(unittest.defaultTestLoader.loadTestsFromTestCase(InnerTest))
        ordering.append('end outer test')

unittest.TextTestRunner(io.StringIO()).run(unittest.defaultTestLoader.loadTestsFromTestCase(OuterTest))
print(ordering)
