Input: `export { default };` in an in-memory language service; asks for the fixMissingImport combined code fix and code fixes at the `default` token.
Clean: `default` is skipped, so no crash and it returns normally.
Injected: a Debug.assert on the `default` symbol name fails, so the call throws.
