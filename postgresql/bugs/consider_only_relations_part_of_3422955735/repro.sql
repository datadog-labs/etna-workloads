CREATE TABLE ptif_normal_table(a int);
SELECT * FROM pg_partition_tree('ptif_normal_table');
SELECT * FROM pg_partition_ancestors('ptif_normal_table');
SELECT pg_partition_root('ptif_normal_table');
