repro.sql checks that scalar subqueries return no subtype: `subtype((SELECT json(0)))` and
`subtype((SELECT json_group_array(1)))`, plus `json_array((SELECT json_group_array(1)))`.
Clean: 0, 0, `["[1]"]`. Buggy: 74, 74, `[[1]]` (the subquery result keeps the JSON subtype).
