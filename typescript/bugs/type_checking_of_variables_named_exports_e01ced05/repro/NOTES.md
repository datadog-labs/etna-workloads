input.ts declares `let exports: string` and assigns a number to it.
Clean tsc reports TS2322 (number not assignable to string); the injected build skips the assignability check for an identifier named `exports`, so it reports no error (exit 0).
