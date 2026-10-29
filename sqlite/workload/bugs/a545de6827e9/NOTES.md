Reproducer: `SELECT 0XFF_FF, 0XFF_EF;` (hex literals with an uppercase `X` and `_` separators).
Buggy shell only recognises lowercase `0x` when stripping underscores, so the uppercase form is mishandled; the clean shell returns `65535|65519`.
