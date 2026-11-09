Input references a type directive with uppercase name (`/// <reference types="UpperPkg" />`) resolved from node_modules/@types/UpperPkg.
Clean build keeps the directive's casing and resolves it; the injected build lowercases the name,
so the resolution/explainFiles output (and diagnostics) differ between clean and injected.
