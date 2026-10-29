repro.sql runs `MIN(a) FILTER (WHERE b>0)` over a sliding ROWS frame (window8-10.1).
With the bug, the FILTER is ignored by the min/max sliding-frame path, so rows
with b<=0 are included: `20 -1` gives 15 instead of 25, and `25 3` gives 20 instead of 25.
