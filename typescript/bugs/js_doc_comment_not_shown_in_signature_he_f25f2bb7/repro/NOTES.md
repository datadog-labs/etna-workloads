a.js has two `@overload` JSDoc blocks with descriptions ("First overload"/"Second overload") before `function f`; the language service is asked for signature help at `f(1)`.
Clean: each overload item shows its description as documentation. Injected: documentation is empty for the overload signatures (JSDocSignature comment lookup lost the overload tag handling).
