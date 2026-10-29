Reproducer: group_concat() where the leading values are empty strings (ticket #3806).
Clean shell outputs `,b,c` and `,,c`; the buggy shell skips the separator while the accumulator is empty, so it outputs `b,c` and `c`.
