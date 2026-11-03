repro.go is upstream test/fixedbugs/issue41872.go. f8/f16 compare a truncated (x&mask) to a constant.
The buggy AMD64 rule CMPBconst/CMPWconst (ANDLconst [m]) checks `0 <= m` instead of `0 <= int8(m)`/`int16(m)`,
folding the compare to a constant LT when it shouldn't. Clean: exits 0. Buggy: panics "wanted true, got false" (exit 2).
