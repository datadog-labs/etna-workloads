create table t(a int, b int);
create statistics s1 on a, b from t;
\d t
