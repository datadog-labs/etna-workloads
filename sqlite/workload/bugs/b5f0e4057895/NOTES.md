Reproducer (repro.sql): sets encoding UTF8, creates and fills a TEMP table, then runs `PRAGMA encoding=UTF16` and selects from the table.

Clean shell: the encoding change is refused because TEMP has content, so the select prints `this is a test`.
Buggy shell: the change is wrongly allowed, so the UTF-8 data is read as UTF-16 and the output is mojibake (`桴獩椠⁳⁡整瑳`).
