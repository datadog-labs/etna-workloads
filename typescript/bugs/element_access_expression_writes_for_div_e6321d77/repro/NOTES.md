Input: an interface with divergent accessor types (setter accepts string|number|boolean, getter returns string), assigned via element access `box['value'] = true`.
Clean: no errors (write type is used). Injected: TS2322 errors, since the read type `string` is used for element-access writes.
