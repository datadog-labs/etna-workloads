repro.sql runs the window.slt query added by the fix: sliding SUM/COUNT/MIN/MAX over
`ORDER BY k RANGE BETWEEN 10 PRECEDING AND 5 PRECEDING` with gaps in k, so the frame goes
non-empty -> empty -> non-empty. The buggy build doesn't retract the old frame when it
becomes empty, so stale state leaks into the later frame (k=40 gets values including the old rows).
