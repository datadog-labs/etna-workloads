Formats `let c = <any[]> [];` via the language service with `insertSpaceAfterTypeAssertion: true`.
Clean keeps the space after the type assertion (`<any[]> []`); the injected build deletes it
(`<any[]>[]`) because the `isNonTypeAssertionContext` check was removed from the delete-space rule.
