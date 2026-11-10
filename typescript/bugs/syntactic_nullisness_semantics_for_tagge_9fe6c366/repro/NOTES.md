Input uses a tagged template call result as the left operand of `??` (`tag`x` ?? "..."`).
Clean tsc treats tagged templates as possibly nullish-unknown (no syntactic nullishness), so it reports "Right operand of ?? is unreachable" style errors only where appropriate; the injected build
omits TaggedTemplateExpression from the syntactic-nullish check, so diagnostics output differs.
