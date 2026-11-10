Input: a .tsx file using a namespaced JSX attribute `prop:foo` on an intrinsic element whose type has a JSDoc-commented `'prop:foo'` property.
The script requests language-service quick info at the attribute.
Clean: shows `(property) 'prop:foo': string` with the doc "This also appears".
Injected: the JsxNamespacedName case is missing in getContainingObjectLiteralElementWorker, so the quick info differs (no doc or symbol).
