# Re-introduced bug (d920b7c9)
Bug: posting a message containing a non-cloneable/untransferred transferable (e.g. FileHandle, web stream not in transferList) or an invalid transferList entry threw a Node `TypeError` with code ERR_MISSING_TRANSFERABLE_IN_TRANSFER_LIST / ERR_INVALID_TRANSFER_OBJECT instead of a `DOMException` `DataCloneError` (code 25), contrary to the HTML structured clone spec.

Hunks:
- src/node_errors.h (both lists): re-added ERR_INVALID_TRANSFER_OBJECT and ERR_MISSING_TRANSFERABLE_IN_TRANSFER_LIST (TypeError + messages) — reverse of the fix's removal.
- src/node_messaging.cc: SerializerDelegate::WriteHostObject's `ThrowDataCloneError(clone_transfer_needed_str)` -> `THROW_ERR_MISSING_TRANSFERABLE_IN_TRANSFER_LIST(env_)`; the three `ThrowDataCloneException(..., clone_untransferable_str)` sites in Message::Serialize (non-object entry, non-JSTransferable, and the host-object fallback) -> `THROW_ERR_INVALID_TRANSFER_OBJECT(env)`. (The fix touched two of these; the release has a third equivalent site, reverted for consistency.)
- src/env_properties.h left as is (unused strings are harmless; hunk only added strings).

Failing tests (all three oracle cases): test-whatwg-webstreams-transfer, test-worker-message-port-transfer-filehandle, test-worker-workerdata-messageport — assert.throws fails since the thrown error is a TypeError with code ERR_MISSING_TRANSFERABLE_IN_TRANSFER_LIST ("Object that needs transfer was found in message but not listed in transferList") rather than DOMException DataCloneError/25.
