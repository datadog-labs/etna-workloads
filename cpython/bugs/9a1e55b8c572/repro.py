import sys
from importlib import util

spec = util.find_spec('json')
loader = util.LazyLoader(spec.loader)
spec.loader = loader
module = util.module_from_spec(spec)
sys.modules['json'] = module
loader.exec_module(module)
print(repr(module.loads('{}')))
