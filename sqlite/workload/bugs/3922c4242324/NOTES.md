repro.sql: a scalar subquery returning json(0) keeps its subtype in the buggy shell (subtype() gives 74, json_group_object emits 0 rather than "0"). The clean shell clears the subtype (0 and "0").
