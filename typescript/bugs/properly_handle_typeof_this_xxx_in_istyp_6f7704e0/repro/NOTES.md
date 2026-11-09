Input: a class method with parameter type `typeof this.x`, called via `new A().a(1)`.
Clean: no diagnostics. Injected: error TS2304 "Cannot find name 'this'" at the `this` in the method signature.
