# Rationale
Today's code had no bundler guard at all (require always resolved; the fix's `shouldResolveJsRequire` helper is gone/inlined away). Re-expressed the pre-fix behaviour: in `--moduleResolution bundler`, JS `require` is never resolved, even with `noDtsResolution` (which Go To Source Definition uses).
- binder.ts (fix hunk: `shouldResolveJsRequire(options)` in bindVariableDeclarationOrBindingElement): re-added `getEmitModuleResolutionKind(options) !== Bundler` check (+ imports).
- checker.ts (hunk at resolveCallExpression require check): re-added the same Bundler check.
- program.ts (hunk in collectExternalModuleReferences): `shouldProcessRequires` is false under Bundler.
- utilities.ts helper and the checker allowSyntheticDefaultImports hunks are refactors, not behaviour; not touched.

SUMMARY: 2/2 oracle cases failing (2 fix-added).
