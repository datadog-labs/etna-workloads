input.tsx uses a namespaced JSX attribute (`ns:thing="a"`) on an element whose props type has a template-literal index signature (`do-${string}`: Function) plus a matching "ns:thing"?: string property.
Clean: no errors (namespaced name is not treated as an expression, so it isn't compared to the non-matching index signature).
Injected: JsxNamespacedName is treated as an expression, so the checker reports a TS2322 error that 'ns:thing' string is incompatible with the index signature (Function).
