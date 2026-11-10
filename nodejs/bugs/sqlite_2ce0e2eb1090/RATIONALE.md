# Re-introduced bug: sqlite Session disposal of an in-use session

**Bug.** `session[Symbol.dispose]()` was implemented as `Close()` wrapped in a `v8::TryCatch` that swallowed every exception. Disposing a session while it was generating a changeset/patchset (e.g. from an authorizer callback) therefore did not throw "session is currently in use". It was silently ignored, and so were other errors.

**Hunk (src/node_sqlite.cc, `Session::Dispose`).** This corresponds to the only implementation hunk of the fix. The fix replaced the TryCatch+Close body with a direct implementation: no-op if closed, throw ERR_INVALID_STATE if `is_generating_changeset_`, then `Delete()`. I restored the pre-fix body (TryCatch around `Close(args)`). Today's code also had `THROW_AND_RETURN_IF_SESSION_IN_CALLBACK`, which is removed along with the rest of the new body. The swallowed exception brings back the old behaviour.

**Failing test.** `parallel/test-sqlite-session` fails (`not ok 1`, stable over 2 runs). The failing case is "session close and dispose - while generating changes throws exception" for the `Symbol.dispose` variant. The expected `ERR_INVALID_STATE` "session is currently in use" is not thrown, because the dispose error is swallowed.
