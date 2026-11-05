create table t (a int, b int, c text);
copy t to stdout with (header match);
