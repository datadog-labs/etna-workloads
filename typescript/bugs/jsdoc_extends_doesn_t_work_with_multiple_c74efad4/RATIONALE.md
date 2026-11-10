# Rationale
Hunk: tree/src/compiler/parser.ts, parseExpressionWithTypeArgumentsForAugments.
Fix.diff added scanner.setInJSDocType(true/false) around tryParseTypeArguments (today named setSkipJsDocLeadingAsterisks). I removed those two calls, so JSDoc `*` leading asterisks on continuation lines break multi-line `@extends` type arguments again.

SUMMARY: 2/6 oracle cases failing (2 fix-added).
