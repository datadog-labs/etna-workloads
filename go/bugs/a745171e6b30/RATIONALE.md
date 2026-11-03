# Rationale

Fix hunk reversed: `xname := x.Extra.(string)` -> `xname := t.Extra.(string)` in `Type.cmp`, `case TSSA`.
In go1.27.3 the file is `src/cmd/compile/internal/types/type.go` (line ~1135) and the field is
lowercase `extra`, so the line is now `xname := t.extra.(string)`. The comment hunk in the fix
(documenting `TSSA: string`) is documentation only and was left alone.

Effect: both names come from `t`, so any two distinct TSSA types (mem, flags, void, int128,
invalid) compare as CMPeq.

Oracle: `TestSSACompare` fails with output such as `mem compare int128 == 0`. The other
oracle cases pass.
