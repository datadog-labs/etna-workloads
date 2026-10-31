Compiles look-behind patterns whose width is very large (`(?<=((.{a}){b}){c})`).
Clean: width 2**44 gives re.error "looks too much behind", and 2**31 compiles.
Buggy: the width is clamped, so the error is "look-behind requires fixed-width pattern", and 2**31 raises RuntimeError "invalid SRE code".
