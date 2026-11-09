Input: a generic call `func({ foo: 1, bar: 1 })` with `T extends { foo: 1 }`. The script requests completions at `bar` via the language service, then asks for semantic diagnostics.
Clean: no diagnostics are reported (inference blocked during the completions request must not leave errors).
Injected: an excess-property error ("'bar' does not exist in type '{ foo: 1; }'") is reported after the completions request.
