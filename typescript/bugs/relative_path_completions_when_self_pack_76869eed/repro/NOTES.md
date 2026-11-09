Input: in-memory project whose package.json has typesVersions {"*": {"*": ["./src/*"]}}, and src/index.ts containing `import { add } from "./";`.
The script asks the language service for string-literal path completions inside "./".
Clean: lists the relative-module completions (e.g. "add"). Injected: passes moduleSpecifierIsRelative=false, so typesVersions
remapping is applied wrongly and the completion list differs.
