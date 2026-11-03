repro.go: generic funcs whose result tuple contains `_` and whose type args can't be inferred (go.dev/issue/59890).
Clean: reports "cannot infer T" for both calls (g() and append(f()())) plus "cannot use _" errors.
Buggy: isParameterized lacks the *Tuple case, so types2 panics ("The following panic happened checking types near ./repro.go:7:5"), and the "cannot infer T" error for g() at 3:13 is missing.
