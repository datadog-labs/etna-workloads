Reproducer for pager1-44.3: after shrinking the DB with incremental_vacuum and setting
max_page_count=2 inside a transaction, ROLLBACK must raise max_page_count back to cover
the restored database. Clean shell prints 30 / 30 after ROLLBACK;
buggy shell prints 30 / 16 (max_page_count not raised).
