Input: a.js with `import { a } from "./foo.js"; a;`; run.js asks the language service for the "Convert named imports to namespace import" refactor.
Clean names the namespace `foo` (`import * as foo from "./foo.js"`); injected doesn't strip the extension and produces a different name (`foo_js`).
