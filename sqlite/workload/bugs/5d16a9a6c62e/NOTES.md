repro.sql runs `PRAGMA PAGE_COUNT` (upper case) on a database with one table.
The injected bug checks the first letter's low nibble instead of matching the name case-insensitively, so the pragma is mis-dispatched to max_page_count.
Clean shell prints 2. Buggy shell prints 4294967294.
