# Rationale

Fix gh-148225 added `_validate_replay_input_file()` (magic/header check) and
wrapped the reader in `try/except (OSError, ValueError)` -> `sys.exit(...)`.
In v3.15.2 `_handle_replay` in `Lib/profiling/sampling/cli.py` still had both,
so I reverted the single hunk in `_handle_replay`: dropped the
`_validate_replay_input_file(args.input_file)` call and the try/except. This
restores the pre-fix behaviour: non-binary files are passed straight to
`BinaryReader`, and reader errors escape as raw tracebacks.
(The helper functions remain, as the pre-fix `_replay_with_reader` body is
equivalent to the old inline code; the helper is now unused.)

Failing oracle cases:
- `test_cli_replay_rejects_non_binary_profile`: error is a raw
  `ValueError: File too small for header`, not SystemExit with the
  "not a binary sampling profile ... --binary" message.
- `test_cli_replay_reader_errors_exit_cleanly`: the mocked ValueError
  propagates instead of SystemExit("Error: ...").
