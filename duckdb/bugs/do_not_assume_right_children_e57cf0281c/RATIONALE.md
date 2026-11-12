# do_not_assume_right_children_e57cf0281c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e57cf0281cef17c5729045f832512a079053f27b ("do not assume right children of a left join carry null values. They can be reintroduced by the join"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/left_outer/left_join_issue_24540.test
