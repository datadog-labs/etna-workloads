Input: a generic function returns an object literal with a getter `get g() { return value; }` (value: T); `w = wrapper(0)` is exported with declaration emit.
Clean emits `readonly g: number;` in the .d.ts; injected emits `readonly g: T;` (leaked type parameter, invalid d.ts).
