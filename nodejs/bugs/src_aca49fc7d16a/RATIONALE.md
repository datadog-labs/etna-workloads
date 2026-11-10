# Bug
`--env-file` did not ignore spaces between `=` and an opening quote, so `KEY=   "value"` was stored as `"value"` (quotes retained) instead of `value`.

# Change (src/node_dotenv.cc, Dotenv::ParseContent)
One hunk: removed `content = trim_spaces(content);` that follows the "value not present" check (after the key is extracted). This corresponds to the fix's added `content = trim_spaces(content);` after `key = trim_spaces(key);` (in today's code it sits after the empty-value early-return, so the removal is re-expressed there). Without it, leading spaces stay in `content`, so the quote detection (`content.front()`) fails and the value is parsed as unquoted.

# Failing test
parallel/test-dotenv: `AssertionError: Expected values to be strictly equal: '"space before double quotes"' !== 'space before double quotes'` (test-dotenv.js:84, SPACE_BEFORE_DOUBLE_QUOTES). Failure is stable across runs.
