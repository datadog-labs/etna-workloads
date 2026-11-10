Input a.ts is a global script that augments `interface String` and `String.prototype.reverse`; the script uses the language service's "Move to file" refactor on the whole file into /String.ts.
Clean: moved code is emitted as-is into /String.ts with no imports/exports.
Injected: because `String` also has declarations in lib.d.ts (`some` instead of `every`), the new file gets an unnecessary import of `String` from a.ts (invalid code).
