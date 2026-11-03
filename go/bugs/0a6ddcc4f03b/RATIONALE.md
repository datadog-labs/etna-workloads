# Rationale

Fix hunk reversed: types2/resolver.go `collectObjects`, `if imp.fake {` -> `if path == "C" {`
(the pkgName is marked used only for the cgo "C" import, not for any fake package from a failed import).
In go1.27.3 the body is `check.usedPkgNames[pkgName] = true` (formerly `pkgName.used = true`); same semantics.
Comment-only hunks and go/types (outside src/cmd/compile) were not touched.

Failing oracle cases: TestFixedbugs and TestFixedbugs/issue43109.go (`import . "/foo"` now yields
an extra "imported but not used" error besides "could not import /foo").
