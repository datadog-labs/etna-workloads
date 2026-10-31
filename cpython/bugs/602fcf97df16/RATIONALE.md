# Rationale

Fix: gh-123177 (pyrepl stray prompt on wrapped lines from cache).

In v3.15.2 the logic moved from `calc_screen` to `Reader.refresh`/`_build_content_lines`
in `Lib/_pyrepl/reader.py`. The fix computed `prompt_from_cache = offset and buffer[offset-1] != "\n"`
and blanked the first rebuilt line's prompt. Here the call
`self._build_content_lines(..., prompt_from_cache=bool(offset and self.buffer[offset - 1] != "\n"))`
now passes `prompt_from_cache=False`, so the detection is effectively omitted (pre-fix behaviour:
the first non-cached line always gets `get_prompt(...)`, drawing a stray prompt mid-logical-line).

Failing oracle case: `TestReader.test_calc_screen_prompt_handling` (screen shows a stray
`... ` prompt in the middle of a wrapped line instead of the continuation text).
