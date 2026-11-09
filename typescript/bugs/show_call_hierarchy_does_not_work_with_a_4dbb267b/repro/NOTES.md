Input: a class with an arrow-function property (`caller = () => { callee(); }`), queried via the language service's prepareCallHierarchy and provideCallHierarchyOutgoingCalls at the property name.
Clean: returns a call hierarchy item for the arrow property (with container name C) and its outgoing call to `callee`.
Injected: the property arrow function isn't treated as a call hierarchy declaration, so the result is different (no item or no outgoing calls).
