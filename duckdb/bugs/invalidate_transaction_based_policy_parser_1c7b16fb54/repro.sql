.bail off
SET current_transaction_invalidation_policy='ALL_ERRORS_INVALIDATE_TRANSACTION';
create table audit(i int);
begin;
insert into audit values (21);
.open --sql 'inser into audit_backup from audit'
insert into audit values (22);
commit;
select count(*) from audit;
