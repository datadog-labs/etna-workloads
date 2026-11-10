Parses `/** See {@link bar} here */` with ts.createSourceFile and prints ts.getTextOfJSDocComment of the doc comment.
Clean build prints `See {@link bar} here`; the injected build adds a trailing space after a name-only link (`{@link bar }`).
