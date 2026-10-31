Runs `python -m json.tool --json-lines x.jsonl` on a two-line JSONL file.
Clean: exit 0 and both objects pretty-printed. Buggy: the lazy generator is consumed
after the file is closed, so it fails with "ValueError: I/O operation on closed file".
