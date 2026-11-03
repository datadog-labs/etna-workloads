# Rationale

Fix (#53535) added `hasAllMethods` (returns true for invalid V or structs with invalid embedded fields) and switched four `missingMethod(...) == nil` call sites to it. In go1.27.3 the helper still exists, so I reverted the call sites to the pre-fix `missingMethod` calls (types2 only; go/types is outside src/cmd/compile):

- `types2/infer.go` (core-type constraint check in `infer`): back to `if m, _ := check.missingMethod(...); m != nil`.
- `types2/instantiate.go` (`implements`): back to `if m, _ := check.missingMethod(V, T, true, Identical, cause); m != nil`.
- `types2/lookup.go` (`assertableTo`): back to `m, _ := check.missingMethod(T, V, false, Identical, cause); return m == nil`.

`hasAllMethods` is left in place, unused. Equivalent to the pre-fix code, so follow-on "missing method" errors are reported for invalid types and for structs with invalid embedded fields.

Oracle failures: TestFixedbugs and TestFixedbugs/issue53535.go (spurious errors for `var _ io.Writer = W{}`, `&M{}`, `&S{}`, `&G[int]{}`).
