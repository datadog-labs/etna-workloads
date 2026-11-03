repro.go instantiates G2 with [2]any, where C2 is `comparable` intersected with `[2]any | int`.
[2]any is only weakly comparable, so the intersection should drop it and the call should be rejected
("[2]any does not satisfy C2"). The buggy compiler uses the weak Comparable check during
type set intersection, keeps [2]any, and accepts the program. It then compiles and runs.
