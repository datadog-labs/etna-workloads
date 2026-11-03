repro.go compares a value whose type is invalid (pointer to undeclared type) with nil.
Clean: only the two "undefined: NotAType" errors.
Buggy: also a spurious "invalid operation: x.f == nil (operator == not defined on untyped nil)" (issue 54405).
