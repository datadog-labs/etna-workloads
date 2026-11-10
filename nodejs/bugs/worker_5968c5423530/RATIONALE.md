# Re-introduced bug: worker terminate() vs. messaging port (nodejs/node#37319)

**Bug.** When a Worker is terminated while it keeps posting messages and the main thread has no 'message' listener, the queued messages are never drained (the port is stopped, or the batch limit is hit), and the still-ref'ed public MessagePort keeps the event loop alive forever. The process hangs after `terminate()`.

**Hunks.**
1. `lib/internal/worker.js` (`[kOnExit]`): removed `removeAllListeners('message')`, `removeAllListeners('messageerror')`, and `this[kPublicPort].unref()` / `this[kPort].unref()`. This corresponds to the fix's worker.js hunk (the fix has a 'messageerrors' typo that was later corrected to 'messageerror'). Without the unref, the ports stay ref'ed after exit.
2. `src/node_messaging.cc` (`MessagePort::Drain`): `OnMessage(kForceReadMessages)` became `OnMessage(kNormalOperation)`. This corresponds to the Drain hunk of the fix. `drainMessagePort()` again honours `receiving_messages_` and the 1000-message batch limit, so stopped ports and large queues are not fully drained. The enum itself is left in place because the other call sites still use it.

**Failing test.** `parallel/test-worker-terminate-ref-public-port` times out (`not ok`, `severity: fail`, `exitcode: -15`, `stack: timeout`) because the process never exits.
