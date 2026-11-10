input.ts does a type-only default import of a JSON file (`import type data from "./data.json"`) under module nodenext in an ESM package.
Clean: no errors (type-only imports need no `type: json` attribute). Injected: error TS1543 on the module specifier.
