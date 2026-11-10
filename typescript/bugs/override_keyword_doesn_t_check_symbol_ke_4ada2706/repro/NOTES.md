Input: a class using `override` on a symbol-keyed member (`[sym]`, `[Symbol.iterator]`) of a derived class whose base has/lacks that member.
Clean: override check uses the member's real symbol-keyed name, so it is checked correctly.
Injected: the name is rebuilt from the symbol's display name, so the lookup misses and the diagnostics differ (wrong or missing override errors).
