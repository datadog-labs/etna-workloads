\set VERBOSITY terse
CREATE TABLE i_am_a_failure() USING i_do_not_exist_am;
CREATE TABLE i_am_a_failure() USING "btree";
