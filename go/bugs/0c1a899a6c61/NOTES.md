Reproducer (repro.sh): declares pointer types whose base is a struct embedding T *inside a function*
(`type P7 *struct{ T }`) and calls promoted methods on them (p.Mv(), p.Mp()).
The spec says methods are not promoted through a defined pointer type, so the clean compiler reports
"undefined" errors. The buggy compiler only applies that check to package-level types, so local types
wrongly compile (no errors, exit 0 vs. errors, exit 1).
