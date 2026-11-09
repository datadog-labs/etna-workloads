# Rationale
Single hunk in `src/compiler/expressionToTypeNode.ts` (import type reuse in `visitExistingNodeTreeSymbols`),
corresponding to the fix's `rewriteModuleSpecifier` hunk, where `return lit` became
`return visitNode(lit, visitExistingNodeTreeSymbols, isStringLiteral)!`.
In today's code the unchanged literal is processed via `reuseNode(context, ...)` (clone + markNodeReuse, the
modern analogue of the visit). I removed that: the original `node.argument` is used as-is, without the
copy/visit, so copied import type nodes keep the unprocessed (original) literal/argument node, reintroducing
the missing-visit bug (e.g. `import('./mod1').Con` text preserved instead of `import("./mod1").Con`).
SUMMARY: 13/66 oracle cases failing (2 fix-added). Local baselines (actual output) are in <workdir>/tree/tests/baselines/local/
