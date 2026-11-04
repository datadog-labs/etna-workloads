repro.sql runs `ceil`/`floor` with an extra scale argument and with a `TO year` datetime field.

- df-clean: each statement fails with "This feature is not implemented: CEIL/FLOOR with scale/datetime is not supported".
- df-buggy: the extra argument is silently ignored and the queries return `ceil(100.1234)` = 101.0 and `floor(5.5)` = 5.0.
