create table t_with_user(a int, user text) as values (1,'test'), (2,null), (3,'foo');
select user from t_with_user;
select * from t_with_user where user = 'foo';
