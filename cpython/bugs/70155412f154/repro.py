from asyncio.proactor_events import _ProactorBasePipeTransport

class Sock:
    def fileno(self): return -1
    def shutdown(self, how): print("shutdown called")
    def close(self): print("close called")

class Proto:
    def connection_lost(self, exc): print("connection_lost", exc)

class T:
    _sock = Sock()
    _protocol = Proto()
    _server = None
    _called_connection_lost = False
    _loop = None

_ProactorBasePipeTransport._call_connection_lost(T(), None)
