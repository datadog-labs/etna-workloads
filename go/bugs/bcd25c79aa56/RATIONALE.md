# Rationale

Fix (issue 74888) removed the `[0]` restriction on two `StructSelect` rules in `dec.rules`. In go1.27.3 the IData rule was split in two (Size>0 / Size==0 => Empty); I restored `[0]` on the rules the fix touched:

- `(StructSelect (IData x)) && v.Type.Size() > 0` -> `(StructSelect [0] (IData x)) ...` (reverses fix hunk 1; the Size==0 -> Empty rule was added later and left alone).
- `(StructSelect x) && x.Type.IsPtrShaped()` -> `(StructSelect [0] x) ...` (reverses fix hunk 2).

Changes are in `_gen/dec.rules` and the matching generated `rewritedec.go` (AuxInt != 0 checks).

## Oracle
`test/fixedbugs/issue74888.go` fails: `internal compiler error: 'f': not lowered: v18, StructSelect PTR PTR`, since selecting field 1 of pointer-shaped `struct{ struct{}; *int }` is no longer decomposed.
