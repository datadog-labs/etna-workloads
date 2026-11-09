Formats `if (true) try {...} finally {...}` via the language service (getFormattingEditsForDocument) and prints the result.
Clean: the try/finally blocks are indented correctly (`if (true) try {` / body indented 4 / `} finally {`).
Injected: smartIndenter no longer excludes Block children of TryStatement, so the blocks get extra indentation.
