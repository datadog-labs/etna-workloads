Input: a JS file (checkJs) with `function toString() { this.yadda; ... }`, so the checker looks up a missing property on a type named `toString`.
Clean: the lookup uses the features Map and reports a normal "Property 'yadda' does not exist" error.
Injected: the lookup goes through a plain object keyed by lib target, so the `toString` type name hits Object.prototype.toString. The output differs from clean (a different or wrong diagnostic, or a crash).
