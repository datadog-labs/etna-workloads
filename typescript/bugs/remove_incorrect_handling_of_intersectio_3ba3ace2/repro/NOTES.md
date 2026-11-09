Declares `Lowercase<`foo/${Path}`>` where Path is `string & {_pathBrand: any}`, then assigns it to a number to print the type in the error.
Clean: the type prints as `foo/${Lowercase<`${Path}`>}` (intersection not distributed).
Injected: it prints as `foo/${Lowercase<string> & { _pathBrand: any; }}` (Lowercase mapped over the intersection members).
