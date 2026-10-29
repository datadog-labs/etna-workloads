repro.sql runs printf('(%2c)', char(1513)) and the '%-2c' variant.
Clean pads by characters: `( ש)` and `(ש )`. Buggy skips the UTF-8 width
adjustment for %c, so it counts the 2-byte character as width 2 and emits `(ש)` for both.
