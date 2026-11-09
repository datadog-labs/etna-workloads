Input: an isolatedDeclarations .tsx file `export const x = <div aria-label="label text" />;` (react-jsx, react types stubbed in memory), and the language service is asked for code fixes for the TS9010 diagnostic.
Clean: returns the fixes "Add annotation of type 'JSX.Element'" and "Add satisfies and an inline type assertion" with their text changes.
Injected: getSynthesizedDeepClone no longer sets parents, so the dashed JSX attribute breaks formatting and getCodeFixesAtPosition throws "Debug Failure. False expression: Token end is child end".
