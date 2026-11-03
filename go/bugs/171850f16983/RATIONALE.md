# Rationale

The fix's logic now lives in `types2/gcsizes.go` (was `noder/sizes.go` and `StdSizes`), and `types2/builtins.go`.

1. `types2/builtins.go` (`_Offsetsof`, `_Sizeof`): removed the `offs < 0` / `size < 0` check that reported `TypeTooLarge "... is too large"`. This reverses the fix's builtins.go hunks. Without it, the negative (overflowed) size or offset goes straight into `constant.MakeInt64`.
2. `types2/gcsizes.go` (`Sizeof`, `*Array`): removed the `esize > maxInt64/n` overflow check, so the size is the plain `esize * n` again. This reverses the fix's array hunk in noder/sizes.go. Sizes can then wrap to 0 or to a positive value (issue 59207).

The other fix hunks (Offsetsof, the struct case, `conf.sizeof`) are left alone.

## Oracle failures
- `test/fixedbugs/issue59190.go` (`Test/fixedbugs/issue59190.go`) fails: the three expected "too large" errors are missing. The compiler only reports "larger than address space" at a later stage.
- The types2 testdata `issue59190.go` / `issue59207.go` fail the same way, since no `TypeTooLarge` error is produced.
