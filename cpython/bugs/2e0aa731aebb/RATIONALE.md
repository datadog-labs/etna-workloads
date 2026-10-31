# Rationale

Fix hunk reversed: in `Reader.process_prompt`, the fix redefined `wlen` locally
because the `wlen` from utils already excludes ANSI escape sequences, which
broke the prompt-length logic (the sequences were discounted twice).

v3.15.2 moved this logic into `Lib/_pyrepl/content.py:process_prompt`, which
computes the width with `utils.wlen(visible_prompt)`. I re-introduced the
double discount: the width is `wlen(visible_prompt)` minus the length of the
ANSI sequences again. Prompts without unbracketed ANSI codes are unaffected;
prompts like `"\033[0;32m>>> \033[0m"` get a wrong (too small) width.

Failing oracle case: `test_pyrepl.test_reader.TestReader.test_prompt_length`
(ANSI prompt returns width != 4).
