# Re-introduced bug: multiple SharedArrayBuffers in postMessage (db55c3cf)

**Bug:** `SerializerDelegate` stored seen SharedArrayBuffers as `v8::Local` handles. V8 opens a handle scope around each `GetSharedArrayBufferId()` call, so the Locals dangle after it returns. Later comparisons can match the wrong buffer, so distinct SABs get de-duplicated. A message holding several SABs then deserializes wrongly.

**Changes (src/node_messaging.cc), each one reverses a hunk of the fix:**
1. The lookup loop compares `seen_shared_array_buffers_[i] == shared_array_buffer` directly. This reverses the hunk that added `PersistentToLocal::Strong(...)`.
2. `push_back(shared_array_buffer)` replaces `emplace_back(Global<...>{isolate, ...})`. This reverses the hunk that stored a persistent handle. The backing-store call has since changed upstream, so it is untouched.
3. The member is `std::vector<Local<SharedArrayBuffer>>` again, not `std::vector<Global<...>>`. This reverses the member-type hunk. The `using v8::Global` line stays because other code still uses it.

**Failing test:** `parallel/test-worker-message-port-multiple-sharedarraybuffers` gives `not ok`. The assertion at line 15 (`deepStrictEqual(message, obj)`) fails. I ran it twice and it failed both times.
