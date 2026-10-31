import signal
import sys
import unittest

def on_alarm(*a):
    raise TimeoutError("hang in _exc_info_to_string")
signal.signal(signal.SIGALRM, on_alarm)

try:
    raise ValueError("loop")
except ValueError as e:
    e.__context__ = e  # self-loop in chained exceptions
    err = sys.exc_info()

class T(unittest.TestCase):
    def runTest(self): pass

signal.alarm(3)
try:
    s = unittest.TestResult()._exc_info_to_string(err, T())
    print(s.count("ValueError: loop"))
except TimeoutError as ex:
    print(ex)
