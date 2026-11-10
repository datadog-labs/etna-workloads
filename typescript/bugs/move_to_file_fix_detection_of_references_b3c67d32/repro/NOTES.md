Input: a module `test.ts` declaring a local `interface Disposable` plus `export interface EditingService extends Disposable`, and a `globals.d.ts` that declares a global `Disposable` too.
The script asks the language service to "Move to a new file" for `EditingService`.
Clean: the local `Disposable` is exported from test.ts and the new file gets `import { Disposable } from "./test"`.
Injected: the name is wrongly treated as a global, so test.ts is left unchanged and the new file has no import (it references the global `Disposable`).
