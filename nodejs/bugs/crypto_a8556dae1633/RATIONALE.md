# Re-introduced bug: KeyObject deserialization in a worker (a8556dae1633)

**Bug.** When a KeyObject is transferred to a worker thread, `NativeKeyObject::KeyObjectTransferData::Deserialize` looks up `crypto_key_object_{secret,public,private}_constructor` from the Environment. Those are only set once `internal/crypto/keys` has been loaded in that environment. A fresh worker may not have loaded it, so the constructor is empty and the worker crashes or fails when it instantiates it (issue #35263).

**Change (src/crypto/crypto_keys.cc).** One hunk: remove the `builtin_module_require()->Call(... internal_crypto_keys_string ...)` block from `Deserialize`. It corresponds to the fix's hunk adding the `native_module_require` call for `internal/crypto/keys`, re-expressed with today's names. The fix's other hunks (making `KeyObjectHandle::Initialize` lazy) are already in the release in a different form, so they are not reverted.

**Failing test.** `parallel/test-crypto-worker-thread` reports `not ok`. The worker fails when it deserializes `workerData`. The run was repeated twice with the same result.
