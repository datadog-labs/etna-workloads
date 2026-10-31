Builds a parent parser with a mutually exclusive group inside a titled argument group, then inherits it via `parents=`.
Clean: `-y`/`-z` conflict is detected and help shows `[-y Y | -z Z]` in usage.
Buggy: the mutex group is recreated on the child parser itself rather than the titled group, so help output differs (and the error may differ).
