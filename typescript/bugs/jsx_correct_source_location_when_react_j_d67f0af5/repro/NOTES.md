Input: a .tsx file with a JSX element on a new, indented line, compiled with `--jsx react-jsxdev`.
The emitted `jsxDEV(..., { fileName, lineNumber, columnNumber }, ...)` call carries the source location.
Clean: location skips leading whitespace (the line/column of `<div>`).
Injected: location starts at the node's pos (including preceding trivia), so the line/column are wrong.
