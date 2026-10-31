Reproducer: a Generic with a ParamSpec whose default is `...` (not a list), subscripted
omitting the ParamSpec (`A[float]`). Clean prints `(float, Ellipsis, float)`; buggy
raises TypeError (the default is spliced into a list-typed args, breaking the later handling).
