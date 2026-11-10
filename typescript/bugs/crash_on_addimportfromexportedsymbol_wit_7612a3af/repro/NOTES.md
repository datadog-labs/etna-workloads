Language-service script: `Derived extends Base`, where Base.foo() returns a default-imported class `Other` (from another file).
Requests class-member-snippet completions in Derived and prints the `foo` entry plus its completion details' code actions.
Clean: the auto-import code action for `Other` is produced (default import name resolved from declaration).
Injected: the default-like export name lookup regresses (GH#52694), so output differs / the call crashes.
