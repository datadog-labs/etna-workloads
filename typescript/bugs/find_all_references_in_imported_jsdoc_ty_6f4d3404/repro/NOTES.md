a.js declares a JSDoc `@callback A` and has `module.exports = {}`; b.js has `@typedef {import("./a").A} A`.
The script runs language-service findReferences on `A` in a.js and prints the reference locations.
Clean: also reports the reference in b.js (`import("./a").A`). Injected: only the a.js reference, since the JSDoc callback tag is no longer treated as a named export.
