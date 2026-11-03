repro.go declares an interface with a blank method `_()` and assigns a type that has a `_` method to it.
Clean: only reports "methods must have a unique non-blank name".
Buggy: also reports a spurious follow-up error, "*T2 does not implement B1 (missing method _)", because types2 no longer skips the blank method.
