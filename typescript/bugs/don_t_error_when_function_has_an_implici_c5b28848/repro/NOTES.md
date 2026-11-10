input.ts has functions with an implicit end-of-body return whose declared return types (`unknown`, `T extends undefined`) are assignable from/to undefined but don't syntactically include undefined/void/any.
Clean tsc --strict reports no errors; the injected build wrongly reports TS2366 "Function lacks ending return statement..." for them.
