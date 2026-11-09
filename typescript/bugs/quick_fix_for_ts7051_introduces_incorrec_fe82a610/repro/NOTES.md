Input: `function fn(f: (...number[]) => unknown) {}` with noImplicitAny; the language service is asked for the "Add parameter name" quick fix (TS7051).
Clean: the edit replaces `...number[]` with `...arg0: number[]`.
Injected: the edit covers only the `...number` part and adds an extra `[]` array type, giving an incorrect type (`...arg0: number[][]`-style).
