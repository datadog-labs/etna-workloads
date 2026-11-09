A JS class property carries a `/** @private */` JSDoc tag. The script calls getEffectiveModifierFlags and then getSyntacticModifierFlags on it.
Clean: syntactic flags are 0 (JSDoc not counted). Injected: syntactic returns the cached effective flags (Private, 2).
