input.ts deletes a readonly, non-optional property under --strict.
Clean reports only TS2704 (operand of delete cannot be a read-only property).
Injected also reports the extra TS2790 (operand of delete must be optional), i.e. a double error.
