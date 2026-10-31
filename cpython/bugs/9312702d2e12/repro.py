import sys, types, typing
from typing import ForwardRef
m = types.ModuleType("fwmod")
sys.modules["fwmod"] = m
exec("""from typing import ForwardRef
MyList = list[int]
MyDict = dict[str, 'MyList']
fw = ForwardRef('MyDict', module='fwmod')
""", m.__dict__)
print(typing.evaluate_forward_ref(m.fw))
