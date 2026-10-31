Calls `agen().aclose().throw(GeneratorExit)` twice. Clean: first raises StopIteration, second raises
RuntimeError "cannot reuse already awaited aclose()/athrow()". Buggy: GeneratorExit propagates
instead of being converted to StopIteration (the conversion in async_gen_athrow_throw was removed).
