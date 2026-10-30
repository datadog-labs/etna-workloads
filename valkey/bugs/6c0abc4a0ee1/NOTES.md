Pushes list 5 3 4 1 2 and runs `SORT testa BY nosort [LIMIT 0 3] STORE testb`.
Clean keeps native list order (5 3 4 1 2 / 5 3 4). Buggy forces ALPHA sorting
when STORE is used on a list, giving 1 2 3 4 5 / 1 2 3.
