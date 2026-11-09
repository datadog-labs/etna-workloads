Uses the language service `findRenameLocations` on namespace `NS` containing a `const enum E`, referenced as `NS.E` and `NS.E.A`.
Clean build lists all rename locations of `NS` (declaration plus the references in the type and value positions).
Injected build restricts the search meaning when renaming, so the const-enum-qualified references are missed (fewer locations).
