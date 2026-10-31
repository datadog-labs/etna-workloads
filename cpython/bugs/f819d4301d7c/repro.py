"""
Reproducer for gh-125984: use-after-free on fut->fut_callback0 in the C
asyncio.Future implementation when the event loop's call_soon is reached
through an evil __getattribute__ that removes the only reference to the
callback right before call_soon is actually invoked.

Translated from the upstream regression test added by the fix:
test.test_asyncio.test_futures.CFutureDoneCallbackTests
    .test_use_after_free_on_fut_callback_0_with_evil__getattribute__
"""
import asyncio
from asyncio import futures


class ReachableCode(Exception):
    """Raised by call_soon to prove it actually ran."""


class SimpleEvilEventLoop(asyncio.base_events.BaseEventLoop):
    def get_debug(self):
        # Suppress tracebacks/warnings asyncio would otherwise print.
        return False

    def __del__(self):
        if not self.is_closed() and not self.is_running():
            self.close()


def main():
    fut_callback_0 = lambda: None

    class EvilEventLoop(SimpleEvilEventLoop):
        def call_soon(self, *args, **kwargs):
            super().call_soon(*args, **kwargs)
            raise ReachableCode

        def __getattribute__(self, name):
            nonlocal fut_callback_0
            if name == 'call_soon':
                # Drop the only remaining reference to the callback that is
                # about to be passed to call_soon, right as the C code looks
                # up the "call_soon" attribute on the loop.
                fut.remove_done_callback(fut_callback_0)
                del fut_callback_0
            return object.__getattribute__(self, name)

    evil_loop = EvilEventLoop()
    fut = futures._CFuture(loop=evil_loop)
    fut.add_done_callback(fut_callback_0)

    try:
        fut.set_result("boom")
    except ReachableCode:
        print("ReachableCode raised")
    else:
        print("no exception raised")

    evil_loop.close()


main()
print("done")
