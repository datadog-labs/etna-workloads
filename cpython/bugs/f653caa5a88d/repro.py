import dis
import _testcapi, _testinternalcapi, _testlimitedcapi

class G:
    @property
    def x(self):
        return 9

_testlimitedcapi.type_modified(G)
for _ in range(1001):
    _testinternalcapi.type_assign_specific_version_unsafe(G, 1000_000_000)
_testinternalcapi.type_assign_specific_version_unsafe(G, 0)
print(_testcapi.type_get_version(G))

def load_x(instance):
    instance.x

g = G()
for _ in range(_testinternalcapi.SPECIALIZATION_THRESHOLD + 5):
    load_x(g)
print(sorted(set(i.opname for i in dis.Bytecode(load_x, adaptive=True)) & {"LOAD_ATTR", "LOAD_ATTR_PROPERTY"}))
