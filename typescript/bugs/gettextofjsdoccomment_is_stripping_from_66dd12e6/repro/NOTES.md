Input: a JSDoc comment `/** See {@link A#m} for details */`, parsed with ts.createSourceFile and rendered via ts.getTextOfJSDocComment.
Clean: prints `See {@link A#m} for details`. Injected: the `#` is dropped (`{@link Am}`).
