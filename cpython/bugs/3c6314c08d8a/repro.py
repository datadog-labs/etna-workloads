import xmlrpc.server

class TestInstance:
    def _dispatch(self, method, params):
        raise ValueError(method, params)

d = xmlrpc.server.SimpleXMLRPCDispatcher()
d.register_instance(TestInstance())
try:
    d._dispatch('method', (1, 2, 3))
except ValueError as e:
    print(repr(e), repr(e.__cause__), repr(e.__context__))
