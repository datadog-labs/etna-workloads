Input: an object with getter `id`, passed through a generic key-filtering mapped type (`as Exclude<K, ...>`); go-to-definition on `obj2.id`.
Clean: returns the getter declaration in `obj`. Injected: returns no definitions because the mapped property's declarations aren't linked.
