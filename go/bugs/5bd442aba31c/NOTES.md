repro.go uses identifiers with an invalid character (`☹x`, `fmt.☹x`) that are not declared.
The parser reports "invalid character ... in identifier". The clean compiler stops there.
The buggy compiler also reports a spurious "undefined: ☹x" / "undefined: fmt.☹x" from types2.
