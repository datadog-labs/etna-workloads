Passes a derived Structure (Base -> Mid with empty _fields_ -> Vector) of two doubles by value
to libm atan2 (gh-62260 / issue18060). Clean prints 3.141592653589793.
Buggy: stginfo->length omits the base ffi offset, so the ffi type is built wrongly and
the result differs or the process crashes (see ./check.sh).
