# Rationale

Fix: Shapify gave all pointers one shape (`*uint8`), except pointers to arrays (issue 49295, slice-to-array-pointer conversions on `~*[N]T` type params).

go1.27.3: `Shapify` in src/cmd/compile/internal/noder/reader.go only collapses pointers to `*uint8` when `basic` is true (constraint is a basic interface), so pointer-to-array type args with a core-type constraint already get distinct shapes. The only way to restore the pre-fix state ("all pointers share a shape", with no array exemption) is to drop the `basic &&` condition:

    if targ.IsPtr() && !targ.Elem().NotInHeap() {

This reverses the fix's added array exception: `Token` (`*[16]byte`) now shapes to `*uint8`, so `T(r.buf[:n])` is compiled for a plain pointer instead of a slice-to-array-pointer conversion.

Oracle: test/typeparam/issue49295.go (both cases) fails.
