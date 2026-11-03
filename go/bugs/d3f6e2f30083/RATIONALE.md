# Rationale

Fix: report "cannot refer to unexported name" only once (previously `restrictlookup`
reported it and the normal lookup path then also reported "undefined").

go1.27 has no noder/restrictlookup; selectors on packages are checked in
types2. Imported unexported names are absent from the package scope, so only
"undefined: pkg.name" is reported. Change in `types2/call.go` (selector, imported
package, `exp == nil` branch): additionally report "name %s not exported by package %s"
when the selector is unexported, before the "undefined" error. This restores the
pre-fix double report (unexported + undefined) on the same line.

Failing oracle cases: Test/fixedbugs/issue22921.go and Test/runtime.go
(Unmatched Errors: the extra "not exported" error alongside "undefined").
