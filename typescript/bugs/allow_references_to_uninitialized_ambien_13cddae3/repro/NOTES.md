Input: a derived class redeclares a property with `declare x: number;` and reads `this.x` in the constructor after `super()`.
Clean: no diagnostics (ambient properties are never treated as uninitialized).
Injected: reports error TS2565 "Property 'x' is used before being assigned".
