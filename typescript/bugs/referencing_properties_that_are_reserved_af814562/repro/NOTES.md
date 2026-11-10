Input: a JS file (checkJs) with a JSDoc `{@link Map.delete}`, where `delete` is a reserved keyword used as a property name.
Clean build parses `delete` as an identifier name and reports no diagnostics.
Injected build uses parseIdentifier, so it reports a syntax error (identifier expected) in the @link.
