repro.sql runs the json103-300 case: json_group_array(x) over rows 1 and 'abc', alongside json_group_array(json_object('x',x)).

With the bug, OP_Column keeps a stale MEM_Subtype flag on the output register. The 'abc' value is then treated as already-JSON, so the first column is `[1,abc]` instead of `[1,"abc"]`. The clean shell prints `[1,"abc"]`.
