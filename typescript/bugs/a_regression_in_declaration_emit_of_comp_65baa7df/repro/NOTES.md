Input declares an exported const whose type comes from a generic call with an object type literal containing string-literal computed property names (`["a_b_c"]`, `["foo bar"]`).
Declaration emit (`--declaration --emitDeclarationOnly`) should keep the non-dynamic computed members.
Clean: the emitted .d.ts keeps `["a_b_c"]` and `["foo bar"]`. Injected: those members are dropped from the .d.ts.
