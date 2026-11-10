# Re-introduced bug: receiveMessageOnPort type check

**Bug:** `MessagePort::ReceiveMessage` (src/node_messaging.cc) only did `CHECK(args[0]->IsObject())`, so passing a non-object (null, 0, -1) aborts the process with an assertion failure, and a non-MessagePort object (`{}`, `[]`) is unwrapped without validation, instead of throwing `ERR_INVALID_ARG_TYPE`.

**Hunk:** the single hunk in `ReceiveMessage` corresponds to the fix's only implementation hunk. The `IsObject() || HasInstance(...)` check that throws `THROW_ERR_INVALID_ARG_TYPE` (message is "The \"port\" argument must be a MessagePort instance" in this release) is replaced by the original `CHECK(args[0]->IsObject())`. `env` is still declared, since it is used later.

**Failing test:** parallel/test-worker-message-port-receive-message crashes (exit -6) at `receiveMessageOnPort(null)` with `Assertion failed: args[0]->IsObject()` in node_messaging.cc.
