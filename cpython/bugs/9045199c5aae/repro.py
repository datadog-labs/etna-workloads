import asyncio, socket
from unittest import mock
from asyncio.proactor_events import _ProactorSocketTransport

loop = asyncio.SelectorEventLoop()
errors = []
loop.set_exception_handler(lambda l, ctx: errors.append(repr(ctx.get('exception'))))
proactor = mock.Mock()
loop._proactor = proactor
fut = loop.create_future()
fut.set_result(1)
proactor.send.return_value = fut

tr = _ProactorSocketTransport(loop, mock.Mock(socket.socket), asyncio.Protocol())
tr.write(b'data')
tr._force_close(None)
loop.call_soon(loop.stop)
loop.run_forever()
print(errors)
loop.close()
