Language-service find-all-references on the module specifier "@foo/dir/jsx-runtime" in foo.ts, with jsx=react-jsx and jsxImportSource="@foo/dir" (bar.tsx has JSX, so it gets a synthetic jsx-runtime import).
Clean: the synthetic implicit import in bar.tsx is reported as an "implicit" reference, so the output differs from the injected build.
Injected: that reference is wrongly treated as a regular import, so the result changes or the call fails.
