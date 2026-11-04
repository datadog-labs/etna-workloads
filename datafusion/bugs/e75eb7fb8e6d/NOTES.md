repro.sql creates a table with a column named `user` and selects `t_with_user.user`.
Clean: returns the two rows (test, NULL). Buggy: planning error "Invalid function 't_with_user.user'"
(the qualified reserved keyword is parsed as a function call and the compound-identifier workaround is missing).
