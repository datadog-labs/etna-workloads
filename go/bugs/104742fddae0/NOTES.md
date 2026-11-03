repro.go declares separate, ungrouped `const x = iota` declarations (package and function level) and prints them.
Clean: every iota is 0 (prints `0 0 0 1 0 0`). Buggy: types2 doesn't reset iota for ungrouped consts, so later ones get an incremented iota.
