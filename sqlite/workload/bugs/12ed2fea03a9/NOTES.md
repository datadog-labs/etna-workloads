Runs `datetime('2000-10-29 12:00 +00:00','utc','utc')` (and the `-00:00` form) with TZ=EST5.
A "+00:00" suffix should behave like "Z" (already UTC), so the 'utc' modifiers are no-ops.
Clean shell: `2000-10-29 12:00:00`. Buggy shell: `2000-10-29 17:00:00` (shifted by the local offset).
A non-UTC TZ is needed, which is why this is repro.sh rather than repro.sql.
