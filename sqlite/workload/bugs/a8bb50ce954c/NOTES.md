`repro.sql` runs `concat_ws(',','',2,3)`. Clean returns `,2,3`. Buggy drops the separator after the leading empty string (it tests `j>0` instead of "a non-NULL argument was seen") and returns `2,3`.
