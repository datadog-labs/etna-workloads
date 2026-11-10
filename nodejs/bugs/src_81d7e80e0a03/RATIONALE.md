# Re-introduced bug: abort in pbkdf2 with an invalid digest containing '%'

**Bug.** `PBKDF2Traits::AdditionalConfig` (src/crypto/crypto_pbkdf2.cc) built the "Invalid digest: <name>"
message with `snprintf` into a local buffer and passed that already-formatted string as the *format*
argument to `THROW_ERR_CRYPTO_INVALID_DIGEST`. A digest name with a `%` (e.g. `'%'`) is then interpreted as a
format directive and the process aborts (assertion in SPrintFImpl) instead of throwing ERR_CRYPTO_INVALID_DIGEST.

**Change (one hunk).** Corresponds to the fix's third hunk (invalid digest). The fix replaced snprintf+throw by
`THROW_ERR_CRYPTO_INVALID_DIGEST(env, "Invalid digest: %s", *name)`. I restored `snprintf(errmsg, ..., *name)` followed by
`THROW_ERR_CRYPTO_INVALID_DIGEST(env, errmsg, "")`. In today's code the macro skips formatting when there are no
extra args, so the pre-formatted message is only treated as a format string if a variadic argument is present;
the trailing `""` argument re-creates that behaviour (the old macro always formatted). The iterations/length hunks
of the fix are not reproduced: their messages contain no user data, so reverting them has no behavioural effect.

**Failing test.** `parallel/test-crypto-pbkdf2` fails (`not ok 1`, stable on repeated runs):
`Assertion failed: (offset) != (std::string_view::npos)` in `SPrintFImpl` (debug_utils-inl.h) -> abort, from the
`crypto.pbkdf2Sync('1','2',1,1,'%')` case.
