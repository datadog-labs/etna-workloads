create table t_with_user(a int, user text) as values (1,'test'), (2,null);
select t_with_user.user from t_with_user;
