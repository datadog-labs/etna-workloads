import os, sys
from test.support import import_helper
sys.pycache_prefix = '/tmp/bytecode'
os.chdir('/')
util = import_helper.import_fresh_module(
    'importlib.util', fresh=('importlib',),
    blocked=('_frozen_importlib', '_frozen_importlib_external'))
try:
    print(repr(util.cache_from_source('qux.py')))
except Exception as e:
    print(type(e).__name__, e)
