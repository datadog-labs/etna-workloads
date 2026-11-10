Input: a function with an unclosed destructured parameter (`export function getHtml({ return "..." }`), with no trailing newline, so a parse-error binding element ends at EOF.
The script uses the API to print syntactic and semantic diagnostics including related information.
Clean: prints the diagnostics, including TS2842 with related TS2843 at end of file (length 0).
Injected: the related diagnostic has length 1, past end of file, so getSemanticDiagnostics crashes with "Debug Failure. Expected 68 <= 67".
