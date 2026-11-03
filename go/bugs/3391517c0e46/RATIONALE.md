# Rationale

Fix: added `types2.Invalid: 1` to `basicSizes` so Sizeof on an invalid type (reached via
unsafe.Sizeof in an erroneous program) doesn't crash.

In go1.27.3 `basicSizes` lives in `types2/sizes.go` and `gcSizes.Sizeof` (`types2/gcsizes.go`) falls
back to `WordSize` for unlisted kinds, so just deleting the entry does nothing. I restored the
pre-fix behaviour (Invalid has no handled size and crashes) by making `gcSizes.Sizeof` panic for
`k == Invalid` in the `*Basic` case. Changed file: `src/cmd/compile/internal/types2/gcsizes.go`.

Oracle: `test/fixedbugs/issue52748.go` fails: the compiler panics ("unreachable") in size
computation instead of reporting "initialization cycle".
