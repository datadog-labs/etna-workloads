# Rationale

Fix hunk (Lib/dis.py, `_disassemble_bytes`): replaced `is_current_instr = instr.offset == lasti`
with a range check so that a `lasti` pointing into an instruction's CACHE entries marks that instruction.

In v3.15.2 the logic lives in `print_instructions` (Lib/dis.py). I restored the pre-fix
`is_current_instr = instr.offset == lasti`, removing the range check against `_get_cache_size`.
(v3.15.2 has no `show_caches` branch there; the pre-fix `==` was the behaviour in both modes.)

Oracle: test_dis fails with 2 failures, including `test_show_currinstr_with_cache`
(lasti at a CACHE offset yields no `-->` marker, so the disassemblies differ).
