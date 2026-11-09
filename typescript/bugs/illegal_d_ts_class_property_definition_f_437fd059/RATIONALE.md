Hunk: tree/src/compiler/checker.ts (serializeAsClass member filter, ~line 10829): removed `|| p.escapedName === "constructor"` from the `p.flags & SymbolFlags.Prototype` condition. Corresponds to the single hunk of fix.diff; without it a JS property named "constructor" is emitted as a class property in .d.ts.

SUMMARY: 1/6 oracle cases failing (1 fix-added)
