Unparses a TemplateStr containing an Interpolation with `str=None`.
Clean: prints `"t'{test1}'"` (falls back to `value`). Buggy: the unparser uses `node.str` unconditionally, so it fails (exception) instead.
