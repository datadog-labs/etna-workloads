Calls inspect.signature on a C method with a default value (`_testcapi.DocStringUnrepresentableSignatureTest.with_default`).
Clean prints `(self, /, x=1)`; buggy fails to find the module via `__objclass__`, so the default can't be evaluated and it raises/prints a different result.
