Input: an exported class with a field, a bodiless constructor overload and an implementation constructor with a default parameter, compiled with target esnext.
Clean: the overload signature is erased from the emitted JS.
Injected: the bodiless `constructor();` overload remains in the emitted JS (invalid JS), because its transformFlags no longer mark it as TypeScript-only.
