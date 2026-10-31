import sys
sys.modules['_interpreters'] = None
from concurrent import futures

try:
    futures.InterpreterPoolExecutor
    print('no AttributeError')
except AttributeError as e:
    print('AttributeError')

try:
    from concurrent.futures import InterpreterPoolExecutor
    print('no ImportError')
except ImportError:
    print('ImportError')

from concurrent.futures import *
print('InterpreterPoolExecutor' in globals())
