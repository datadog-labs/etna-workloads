Compiles a function that calls a method on an interface holding a struct that embeds an interface (issue 42279), with `-gcflags=-m`.
Clean compiler prints "partially devirtualizing i.M to T" and "T{} does not escape". Buggy compiler instead prints "failed to devirtualize ..." and T{} escapes to heap.
