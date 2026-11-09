Requests interactive inlay hints (function parameter types) for `test((state) => {})`, where the parameter type contains a computed property name `[STATE_SIGNAL]`.
Clean: prints hint display parts including `[`, `STATE_SIGNAL`, `]`.
Injected: the ComputedPropertyName case is missing, so it crashes (Debug failBadSyntaxKind), printed as "crash: ...".
