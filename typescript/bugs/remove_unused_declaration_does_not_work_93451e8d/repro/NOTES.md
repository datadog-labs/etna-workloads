Input: overloaded function `foo` (two overloads + implementation), unused, with noUnusedLocals; the script asks the language service for code fixes on the unused diagnostic.
Clean: the "Remove unused declaration for: 'foo'" fix deletes all overloads and the implementation.
Injected: that fix is missing for the identifier, so the fix list/text changes differ (no whole-function deletion).
