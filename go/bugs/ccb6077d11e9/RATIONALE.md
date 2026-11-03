# Rationale

Fix hunk reversed: types2/subst.go (`subster.typ`) gained a `case *Alias:` so that
substitution no longer reaches `default: panic("unreachable")` when a type
contains an alias (e.g. `type A = int; type T[P any] *A; var _ T[int]`).

In go1.27.3 the `case *Alias:` already exists (extended for parameterized
aliases), so a plain reverse doesn't apply. I deleted that whole case in
src/cmd/compile/internal/types2/subst.go, restoring the pre-fix state where
`*Alias` falls to the default branch and panics "unreachable". (go/types is not
under src/cmd/compile, so its identical hunk is untouched.)

Failure: any substitution that traverses an alias type panics with
"internal compiler error: panic: unreachable". Since gotypesalias is now on by
default, this also breaks building the stdlib (sync/atomic, internal/abi, ...),
so the types2 test package fails to build: all 592 oracle cases fail.
