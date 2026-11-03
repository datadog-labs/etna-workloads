# Rationale

Fix: add `ir.OMIN, ir.OMAX` to the "no call needed" list in `walk.mayCall`.

## Changes
1. `src/cmd/compile/internal/walk/walk.go` (`mayCall`): removed the
   `case ir.OMIN, ir.OMAX` (which now returns true only for string/float).
   OMIN/OMAX are again unhandled and fall into `default: FatalfAt("mayCall")`,
   the pre-fix state (reverses the fix hunk).
2. `src/cmd/compile/internal/walk/order.go` (`expr1`): removed `ir.OMAX, ir.OMIN`
   from the case that copies call-like exprs into temporaries. This is a second
   path that, in go1.27.3, keeps min/max from ever reaching `mayCall`
   (walk sees an ONAME temp). Without removing it, the bug is not reachable.
   Same defect: min/max reaching `mayCall` unhandled.

## Oracle
`test/fixedbugs/issue60582.go` fails: the compiler crashes with
`internal compiler error: mayCall ... MAX uintptr` (while building runtime), so
both oracle cases fail.
