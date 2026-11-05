# Rationale
File: src/backend/utils/adt/timestamp.c, functions timestamp_part_common and timestamptz_part_common (the DTK_ISOYEAR cases).
Traces to the two fix.patch hunks in timestamp_part / timestamptz_part that added "Adjust BC years: if (result <= 0) result -= 1".
Removing that adjustment brings back the bug: date2isoyear returns zero or negative years, which are not converted to the BC convention, so EXTRACT(ISOYEAR) is off by one for BC dates.
The comment-only hunk in date2isoyear was not touched.

Failing oracle cases: src/test/regress||timestamp, src/test/regress||timestamptz
