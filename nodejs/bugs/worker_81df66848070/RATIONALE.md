# Re-introduced bug: untransferable value in a JSTransferable's transfer list crashes

**Bug.** When serializing a host object, the transfer list was searched for the object
*before* checking whether it is untransferable. A JSTransferable whose transfer list contains
an untransferable object (e.g. an already-detached/closing MessagePort or FileHandle) therefore
got serialized as a transferred index and later hit a hard assertion (`Assertion failed: data_`)
instead of throwing a DataCloneError.

**Change** (src/node_messaging.cc, `SerializerDelegate::WriteHostObject(BaseObjectPtr<BaseObject>)`).
Corresponds to the fix's single hunk, reversed and adapted to today's code (modes are now
`kDisallowCloneAndTransfer` / `kTransferable` bit flags, and the error is `clone_transfer_needed_str`):
the host_objects_ lookup loop is moved back before the `GetTransferMode()` /
`kDisallowCloneAndTransfer` check, and the transfer-needed error stays after it, as before the fix.

**Failing test.** `parallel/test-worker-message-port-jstransferable-nested-untransferable`:
`not ok`, process aborts with `Assertion failed: data_` (stable over 2 runs).
