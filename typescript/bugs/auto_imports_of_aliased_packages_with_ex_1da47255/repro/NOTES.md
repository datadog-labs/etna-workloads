Input: `node_modules/@monorepo/utils` is a real package dir whose package.json has `"name": "utils"` and an `exports` field. input.ts's declaration emit needs a module specifier for a type from it (reached via another package).
Clean emits `import("@monorepo/utils").Thing` (uses the directory name); injected uses package.json `name` and emits `import("utils").Thing`.
