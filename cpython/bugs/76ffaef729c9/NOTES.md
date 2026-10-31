Exhausts an async generator, then calls `anext(it, ('a','b'))`. The buggy build
doesn't clear StopAsyncIteration before setting StopIteration(default), so the
debug build hits an assertion (or SystemError) instead of printing `('a', 'b')`.
