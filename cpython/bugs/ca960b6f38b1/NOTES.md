Reproducer creates package `pkg` and runs a module doing `lazy from .target import VALUE` and
`lazy from . import target` with a lazy-imports filter installed, then prints what the filter saw.
Clean: filter receives resolved names ("pkg.target", "pkg"). Buggy: it receives the unresolved relative names.
