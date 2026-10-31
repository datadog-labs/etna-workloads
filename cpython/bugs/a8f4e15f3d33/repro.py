import asyncio, asyncio.unix_events as ue, signal, warnings
from unittest import mock

loop = asyncio.SelectorEventLoop()
loop.add_signal_handler(signal.SIGHUP, lambda: True)
with mock.patch.object(ue.sys, 'is_finalizing', return_value=True):
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter('always')
        try:
            loop.close()
        except BaseException as e:
            print('error:', type(e).__name__, e)
        print([str(x.message).split(' on interpreter')[1] for x in w if x.category is ResourceWarning])
print(len(loop._signal_handlers))
