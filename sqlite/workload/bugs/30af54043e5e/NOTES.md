repro.sql builds the three tables from existsexpr-13 and runs the nested EXISTS query.
Clean shell returns `7|10`. The buggy shell lacks the nested-EXISTS break handling, so the result differs (see ./check.sh).
