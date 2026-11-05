CREATE PUBLICATION testpub_parsertst FOR TABLE pub_test.testpub_nopk, CURRENT_SCHEMA;
CREATE PUBLICATION testpub_parsertst FOR TABLES IN SCHEMA foo, test.foo;
