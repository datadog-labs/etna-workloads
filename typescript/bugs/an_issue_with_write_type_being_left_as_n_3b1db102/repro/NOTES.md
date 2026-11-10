Input: a generic class with a setter `set x(x: T)`, cast to `GenericObject & ({a?:string}|{b?:number})`, then `v1.x = 432`.
Clean: no errors. Injected: bogus TS2322 "Type 'number' is not assignable to type 'T'" because the merged
instantiation's write type is left non-instantiated.
