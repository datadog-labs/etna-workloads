Input destructures a nested binding pattern `const [[p1, p1Error]] = arg` from a tuple-union, then narrows via `if (p1Error) return;`.
Clean: p1 is narrowed to `number`, so no diagnostics. Injected: the nested pattern isn't narrowed (p1 stays `number | undefined`), giving error TS2322 on `const n: number = p1`.
