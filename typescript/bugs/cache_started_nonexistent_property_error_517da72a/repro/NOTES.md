Input: an object literal whose method returns an object with a computed key `[this.a]`, where `a` does not exist on `this` (strict, declaration on).
Clean: reports the "Property 'a' does not exist" error once (reentrant check is cached).
Injected: the nonexistent-property error is reported again on reentry, so the diagnostics output differs (duplicate error).
