# Rationale
Hunk: tree/src/services/stringCompletions.ts, property-value-in-call case (`findAncestor(parent.parent, isCallLikeExpression)`).
Fix.diff made string literal completions use `ContextFlags.Completions` (ignore node inferences) so a partially-typed string that fixes a type parameter doesn't hide other candidates. In today's code that is `ContextFlags.IgnoreNodeInferences`, merged with the `None` result. I removed the IgnoreNodeInferences lookup, so only the inference-fixed type is used -> completions only `''` instead of `'', 'bar', 'baz'`.
(utilities.ts hunk of fix only added a parameter plumbing; left in place, since it is now unused-by-this-path but still used elsewhere.)

SUMMARY: 1/1 oracle cases failing (1 fix-added).
