input.ts assigns a number and an object literal to `Uppercase<string>`.
Clean tsc reports two TS2322 errors (exit 2); the injected build treats everything as assignable to the string mapping, reporting no errors (exit 0).
