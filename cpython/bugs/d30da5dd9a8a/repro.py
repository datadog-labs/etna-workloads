import typing
for n in ('ForwardRef', 'ChainMap', 'OrderedDict'):
    print(n, n in typing.__all__)
ns = {}
exec('from typing import *', ns)
print([n for n in ('ForwardRef', 'ChainMap', 'OrderedDict') if n in ns])
