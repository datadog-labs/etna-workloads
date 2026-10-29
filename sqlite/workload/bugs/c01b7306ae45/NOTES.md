`repro.sql` runs an EXCEPT compound SELECT with `ORDER BY a COLLATE nocase` (selectE-1.0).

- Clean shell: prints `def` and `ghi`.
- Buggy shell: prints only `ghi`. The ORDER BY collation is used for the EXCEPT comparison, so 'def' is wrongly removed by 'DEF'.
