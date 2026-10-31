Starts an asyncio server whose client_connected_cb coroutine closes the writer and cancels its own task,
then connects a client and reports the messages sent to the loop exception handler.
Clean: no messages (`0 []`). Buggy: the done-callback calls `task.exception()` on a cancelled task,
raising CancelledError, so the handler gets 1 message ("Exception in callback StreamReaderProtocol.connection_made.<locals>.callback()").
