# Rationale

## Hunks changed

1. `escape/escape.go` (`walkFunc`): removed the `if n.Label.IsBlank() { break }` guard. This reverses fix hunk 1, so blank labels are again recorded in `e.labels`.
2. `escape/stmt.go` (`stmt`, `OLABEL`): removed the same guard. This reverses fix hunk 2.
3. `typecheck/typecheck.go` (`OLABEL`): removed the code that replaces a blank label with an empty `OBLOCK`. The fix has no hunk for this. It is the second path that covers the same case: it hides the bug from escape analysis. With only hunks 1 and 2 reverted, `check.sh` showed 0 oracle failures, because typecheck had already removed every blank label before escape ran. Removing the elimination lets blank labels reach escape analysis, which is the pre-fix condition (the fix's guards exist for blank labels reaching escape).

## Failure

With several `_:` labels in one function, `walkFunc` stores a single `e.labels[_]` entry. The first `_:` deletes it in `stmt`, so the second finds no tag. The compiler then calls `base.Fatalf("label %v missing tag")`.

Oracle `Test/fixedbugs/issue52278.go` fails with `internal compiler error: label _ missing tag`. `TestShouldTest` still passes.
