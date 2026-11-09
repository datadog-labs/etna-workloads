Input: a class with computed members (`[key]`, `["lit"]`, `[1]`, `[Symbol.iterator]`), queried via the language service's getNavigationBarItems.
Clean build lists the computed members (identifier, string and numeric-literal keys) in the nav bar.
Injected build drops them (only `Symbol.*` names are kept), so the output differs.
