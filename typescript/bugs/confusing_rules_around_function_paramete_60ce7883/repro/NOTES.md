Input declares a function type whose parameter is a destructuring pattern with a default (`{ first = 0 }`) and no body.
Clean tsc reports TS2371 (parameter initializer only allowed in implementation) at 1,15 and exits 2.
Injected tsc checks only `isParameter(node)`, so the binding element's initializer is missed: no error, exit 0.
