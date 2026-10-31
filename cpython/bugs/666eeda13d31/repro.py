from typing import Protocol, get_protocol_members

class DeferredProto(Protocol):
    x: DoesNotExist

try:
    print(repr(get_protocol_members(DeferredProto)))
except BaseException as e:
    print(type(e).__name__, e)
