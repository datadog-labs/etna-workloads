`repro.go` declares constants whose `^` (XOR) and unary complement overflow the 512-bit untyped constant limit.

Both toolchains reject it, but the messages differ:
- clean: `constant bitwise XOR overflow` and `constant bitwise complement overflow`
- buggy: plain `constant overflow` for both, because the injection removes the `syntax.Xor` entries from `op2str1` and `op2str2` in types2/expr.go.

I ran both toolchains directly rather than through `./check.sh`. It failed in the sandbox with a bwrap error about a missing `.claude/launch.json`.
