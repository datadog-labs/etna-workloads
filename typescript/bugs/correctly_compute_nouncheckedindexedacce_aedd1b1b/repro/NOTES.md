Input applies `+=` and `++` to index-signature elements (`o[k]`, `o.a`) under `noUncheckedIndexedAccess`.
Clean: reading the compound target includes `undefined`, so tsc reports "Object is possibly 'undefined'" errors.
Injected: compound/increment targets are treated as plain assignment targets, so those errors are missing.
