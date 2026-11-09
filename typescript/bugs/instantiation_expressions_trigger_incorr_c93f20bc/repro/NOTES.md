Input: `interface Comparable {}` used as a class `extends` expression (`class A extends Comparable {}`).
The script calls `checker.getSymbolAtLocation` on the `Comparable` identifier in the heritage clause.
Clean: returns undefined (an interface is not a value, so no symbol). Injected: returns the interface symbol
`Comparable`, because the name is resolved with Type meaning regardless of value/type space.
