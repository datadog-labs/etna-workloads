# Rationale

Fix: `Tsubster.tstruct` (typecheck/subr.go) copied `Embedded` but not `Note` (the struct tag) when substituting a generic struct. That function no longer exists; in go1.27.3 (unified IR) instantiated struct types are built by `reader.structType` in `src/cmd/compile/internal/noder/reader.go`.

Change: `field.Note = r.String()` became `_ = r.String()`, so the tag is still read from the export data but never saved on the field. This is the same defect: field tags dropped when constructing a struct type for an instantiation.

Oracle: `Test/typeparam/issue48317.go` fails. json.Unmarshal ignores the tags, and Marshal then panics with `{"F1":"","F2":0,"B":{"F4":0}}`. `TestShouldTest` passes.
