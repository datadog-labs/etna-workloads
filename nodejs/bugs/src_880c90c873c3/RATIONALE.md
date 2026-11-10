# Re-introduced bug: dotenv double-quoted value terminates at the last quote on the line

**Bug.** The dotenv parser looked for the *last* matching quote on a line instead of the first one after the opening quote. `KEY="VALUE1" # or "VALUE2"` therefore produced `VALUE1" # or "VALUE2` instead of `VALUE1`.

**Hunk (src/node_dotenv.cc, double-quote branch of `Dotenv::ParseContent`).** This corresponds to the fix's change from `value.find_last_of(quote_character)` to `value.find(quote_character)`. The release now parses the whole buffer rather than line by line, so the old code could not be restored by reversing the diff. The change searches the current line (up to the first `\n`) with `rfind` for the last quote character, which brings back the old `find_last_of` behaviour. If that finds no closing quote, it falls back to the current `find(quote, 1)`, so multi-line double-quoted values still work.

**Failing test.** `parallel/test-dotenv` fails on both runs:
`actual: 'VALUE1" # or "VALUE2" or "VALUE3'`, `expected: 'VALUE1'` (the `EDGE_CASE_INLINE_COMMENTS` assertion).
