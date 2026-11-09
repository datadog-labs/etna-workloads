Input: a class with `accessor [f()] = 1;` (computed-name auto-accessor) plus other accessors, compiled with --target es2022.
Clean: the private storage field is `#_a_accessor_storage`, and the computed key temp is `_a`.
Injected: name generation scope is wrong, so the storage field becomes `#_e_accessor_storage` (differs from clean output).
