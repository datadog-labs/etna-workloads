repro.go selects a field/method on a built-in (`len.Println`, `_ = len.Println`).
Clean toolchain reports "invalid use of len (built-in) in selector expression" for both lines.
Buggy toolchain drops the builtin check in types2 `selector`, so the second line gets no error
and the first gives only a misleading "len.Println (invalid operand) is not used".
Both exit 1; the compile output differs.
