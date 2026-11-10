# Bug
`readline` `Interface.question()` did not check whether the interface was already closed. Calling it after `close()` set the prompt to the query and registered a callback that never fires (promisified version never settles) instead of throwing `ERR_USE_AFTER_CLOSE`.

# Change
`lib/internal/readline/interface.js`: removed the `if (this.closed) throw new ERR_USE_AFTER_CLOSE('readline')` guard at the top of `[kQuestion]` (today's equivalent of `question()` in the fix hunk). The error code definition in errors.js and the import still exist (used by other methods), so no other hunks are needed.

# Failing tests
- parallel/test-readline-interface
- parallel/test-readline-promises-interface

Both fail with `AssertionError [ERR_ASSERTION]: Expected "actual" to be strictly unequal to: 'How are you?'` (the prompt was changed by question-after-close; the expected throw is also absent).
