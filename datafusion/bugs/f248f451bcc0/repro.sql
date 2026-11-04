SELECT
  regexp_instr('abc', ''),
  regexp_instr('', ''),
  regexp_instr('abc', '', 4),
  regexp_instr('abc', '', 5),
  regexp_instr('😀', '', 1, 2),
  regexp_instr('abc', 'x*', 4),
  regexp_instr(NULL, '');
