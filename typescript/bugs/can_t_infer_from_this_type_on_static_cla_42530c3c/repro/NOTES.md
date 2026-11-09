Input is a JS file (checkJs) with a function using JSDoc @this {{n:number}}, attached to an object literal and called with a mismatched this (n: string).
Clean reports TS2684 (this context not assignable) and exits 2; injected ignores the @this tag, so no error and exit 0.
