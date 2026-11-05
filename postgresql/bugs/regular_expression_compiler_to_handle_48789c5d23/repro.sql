set statement_timeout='20s';
select 'a' ~ '(^)+^';
select 'a' ~ '$($$)+';
select 'a' ~ '($^)+';
select 'a' ~ '(^$)*';
select 'aa bb cc' ~ '(^(?!aa))+';
select 'aa x' ~ '(^(?!aa)(?!bb)(?!cc))+';
select 'dd x' ~ '(^(?!aa)(?!bb)(?!cc))+';
