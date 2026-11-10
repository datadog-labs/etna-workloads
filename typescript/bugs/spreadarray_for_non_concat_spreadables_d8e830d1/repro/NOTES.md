Compiles with target es5 an array literal spreading an array-like object (`[1, ...al]`) and runs the output.
Clean `__spreadArray` copies via `Array.prototype.slice.call(from)`, giving `[1,"a","b"]`.
Injected uses `to.concat(from)`, so the object is appended as a single element: `[1,{...}]`.
