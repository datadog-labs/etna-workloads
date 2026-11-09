Input: a JS file exporting an object literal with a get-only accessor, compiled with allowJs + declaration emit.
Clean emits `const getter: string;` inside `export namespace t1`; the injected build emits `let getter: string;`.
