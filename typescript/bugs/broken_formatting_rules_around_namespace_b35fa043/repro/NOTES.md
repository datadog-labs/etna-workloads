Input: a .tsx file with a JSX element using namespaced attribute names (`ns: foobar`, `x : test1`, `x :test2="string"`), formatted via the language service `getFormattingEditsForDocument`.
Clean: the spaces around the namespace colon are removed (`<ns:foobar x:test1 x:test2="string" ...`).
Injected: the "SpaceAfterColon" rule is applied and the NoSpace*JsxNamespaceColon rules are missing, so spaces remain or are inserted around the colon.
