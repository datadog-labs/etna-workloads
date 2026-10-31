# Rationale

Fix gh-97556 added `E_ERROR` checks after `tok_nextc()` in the tokenizer's string loops. In v3.15.2 the code lives in `Parser/lexer/lexer.c`. I removed both checks:

1. `tok_get_normal_mode`, "Get rest of string" loop: dropped the `if (tok->done == E_ERROR) return MAKE_TOKEN(ERRORTOKEN);` block (fix hunk 1). The `E_DECODE` break is unchanged.
2. `tok_get_fstring_mode`: the check is now `E_ERROR || E_DECODE`. I reduced it to `E_DECODE` only, which removes the `E_ERROR` part added by fix hunk 2. The `E_DECODE` part came from later code.

A null byte in a multiline string or f-string sets `tok->done = E_ERROR` and the tokenizer keeps reading. This makes the null-byte SyntaxError unreliable: the assert in `helpers.c` (`tok->done != E_ERROR`) is hit.

Oracle failure: `test_cmd_line_script.CmdLineTest.test_syntaxerror_null_bytes_in_multiline_string` fails. The interpreter crashes with an assertion (stderr shows a backtrace) instead of printing `SyntaxError: source code cannot contain null bytes`.
