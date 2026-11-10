input.ts calls undefined `foo` with an object literal of 20 string properties; run.mjs asks the language service for code fixes (TS2304) at `foo`.
Clean: "Add missing function declaration" prints a full, untruncated `arg0: { prop001: string; ... prop020: string; }` signature.
Injected: NoTruncation flag is dropped, so the type is truncated (or the fix throws a Debug Failure), so output/exit status differs.
