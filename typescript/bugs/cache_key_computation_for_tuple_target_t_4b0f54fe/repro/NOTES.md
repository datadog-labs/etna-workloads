Input is the partiallyNamedTuples2 scenario (issue 55693): a variadic conditional type builds `[...Rest, Value]` from the partially named tuple `[id1: string, id2: string]`.
Deliberately assigning the result to `number` makes tsc print the resulting type in the error.
Clean prints `Iterable<[id2: string, object]>`. Injected prints `Iterable<[string, id2: object]>`, because the tuple target cache key ignores member positions.
