Reproducer for select7-7.7: a TEXT column compared with an INT column in HAVING after GROUP BY.
The buggy shell's comparison opcodes leave the operand converted by affinity, so the column read afterwards shows the wrong type.
Expected (clean): `text|123`. See ./check.sh for the buggy output.
