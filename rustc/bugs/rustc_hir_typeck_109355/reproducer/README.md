Type-mismatch errors on a field-init shorthand (`Foo { t }`) should suggest `t: t.clone()` / `t: t.is_some()`; the injected compiler suggests the invalid `t.clone()` / `t.is_some()` instead.
