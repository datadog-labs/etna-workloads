repro.sql copies the aggregate.slt record added by the fix (issue #15291). It runs three COUNT(a) FILTER aggregates with a shared subexpression `b*b`.
Clean build returns one row `3 1 1`. Buggy build fails with "Optimizer rule 'common_sub_expression_eliminate' failed ... Schema error: No field named ...".
