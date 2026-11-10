# Bug
The default test-file glob in the test runner used the character class `[.-_]` in `*[.-_]test`. Inside a class, `.-_` is a range (0x2E–0x5F), not the three literals `.`, `-`, `_`. The range wrongly matches many characters (digits, uppercase letters, `/`, etc.) and misses `-`... (`-` is 0x2D, outside the range), so `index-test.js` is not discovered, while files like `latest.js` match (issue #54726).

# Change
`lib/internal/test_runner/utils.js`, `kPatterns`: `'*[._-]test'` -> `'*[.-_]test'`. This corresponds to the single hunk of the fix, reversed (line moved, but same code).

# Failing test
`parallel/test-runner-cli` fails (stable over repeated runs): the "-test.(c|m)js suffix" case (matching-patterns fixtures, which the fixture-less tree lacks only if absent) gives
`AssertionError: The input did not match the regular expression /ok 1 - this should pass/`.
