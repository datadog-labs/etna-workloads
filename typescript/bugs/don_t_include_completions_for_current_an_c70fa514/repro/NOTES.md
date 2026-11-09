Input: `function f(a = /*here*/, bb = 1, cc = 2) {}`; the script asks the language service for completions inside the default of `a`.
Clean: the current and later parameters (a, bb, cc) are filtered out, so the script prints an empty line.
Injected: the filter is missing, so it prints `a,bb,cc`.
