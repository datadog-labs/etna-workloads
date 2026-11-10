input.ts has a /u regex with an astral-character range `[😀-😁]`, scanned by the regex scanner.
Clean: no diagnostics. Injected: scanSourceCharacter treats the astral char as a lone surrogate (size 1), so a false "Range out of order in character class" style error appears.
