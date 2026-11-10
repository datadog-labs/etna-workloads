Input: `Iterable<A> & AsyncIterable<B>` iterated first with `for...of`, then with `for await`, assigning the element to a `number`.
Clean: the `for await` element type is B, so the error reads "Type 'B' is not assignable to type 'number'".
Injected: the sync iteration result spoils the cached async result, so the message names a different type (A).
