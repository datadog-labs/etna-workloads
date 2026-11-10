Input: class C with static methods/getters using `this`, plus a nested `class Inner { x = this; }`.
The script runs language-service findReferences on `C` and prints each reference's line and text.
Clean: `this` references from C's static members only. Injected: also includes the `this` in the nested class Inner's property initializer (crosses class boundary).
