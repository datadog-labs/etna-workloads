repro.sql selects arrow_typeof() of an all-NULL column in a VALUES list.
Clean build: the column type is Null. Buggy build: it falls back to Utf8
(the injection changes the all-NULL fallback type in LogicalPlanBuilder::values).
