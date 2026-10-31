Reproducer: start `agen.asend(None)` and send once (generator now running), create a second
`asend(None)` awaitable and call `.throw(MyExc)` on it, then `.send(None)`.
Clean: RuntimeError "anext(): asynchronous generator is already running", then
"cannot reuse already awaited __anext__()/asend()". Buggy: throw() doesn't check the running
state, so it throws into the running generator and the output/messages differ.
