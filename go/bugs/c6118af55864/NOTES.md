repro.go computes (-0)+0 for float64 and float32 (the issue27718 scenario) and prints 1/result.

Clean: prints `+Inf +Inf`, exit 0.
Buggy: the compiler hits an internal compiler error while building the runtime package
(index out of range in rewriteValuegeneric_OpArraySelect), exit 1.

Caveat: the semantic bug (x+0 folded to x) did not show up in the buggy toolchain's output.
injection.patch appears to have been applied at stale line offsets in rewritegeneric.go for
go1.27.3, so the rules landed inside the wrong rewrite functions, and the visible difference
is this ICE. The ICE happens with a cold build cache, and the reproducer itself does not
trigger it directly.
