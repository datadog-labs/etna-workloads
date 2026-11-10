Input: a non-const enum whose members are syntactically strings (`a${Ext.X}`, "b" + Ext.X) but can't be constant-evaluated (reference to an ambient non-const enum).
Clean emits `E["A"] = ...` with no reverse mapping; injected emits `E[E["A"] = ...] = "A"`, adding a reverse mapping.
