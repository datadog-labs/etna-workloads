Input intersects `{disabled?: boolean | undefined}` with `{disabled?: boolean}` under exactOptionalPropertyTypes, then assigns `undefined` to the property.
Clean: error TS2412 (undefined not assignable to boolean with exactOptionalPropertyTypes).
Injected: the union intersection mixes undefined/missing types wrongly, giving a plain TS2322 instead.
