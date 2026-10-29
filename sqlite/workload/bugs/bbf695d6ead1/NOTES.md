`repro.sql` sets the database encoding to UTF-16be and runs `hex(ltrim(x'6efcda'))`. The blob has an odd length (3 bytes), so converting it to text for UTF-16 exercises the odd-length handling in `sqlite3VdbeMemTranslate`.

- Clean shell: prints `6EFC`.
- Buggy shell: prints `6EFCFFFD`. The trailing odd byte is treated as a character and turned into U+FFFD.
