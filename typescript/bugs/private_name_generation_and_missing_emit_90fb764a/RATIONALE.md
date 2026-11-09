# Rationale
One hunk, tree/src/compiler/transformers/classFields.ts, `shouldTransformAutoAccessorsInCurrentClass()`.
Fix hunk: it introduced `Ternary.Maybe` for `shouldTransformAutoAccessors`, so with target ESNext and
`useDefineForClassFields:false` auto-accessors are still transformed when the class hoists initializers
to the constructor. Before the fix, ESNext meant "never transform". I removed the `Maybe` branch so the function
returns `shouldTransformAutoAccessors === Ternary.True`, which brings back the missing emit/transform for those classes.
Result: autoAccessor9.ts "Correct JS output" fails (a fix-added case).
SUMMARY: 1/132 oracle cases failing (1 fix-added).
