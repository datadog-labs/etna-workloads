Input: a class with `x = 1; accessor y = 2; z = 3;` compiled with target esnext and useDefineForClassFields=false.
Clean: the auto-accessor is lowered to a `#y_accessor_storage` field plus get/set, initialized in the constructor.
Injected: the accessor is left as `accessor y = 2;` while the constructor assigns a bogus `this.#y_1 = 2`.
