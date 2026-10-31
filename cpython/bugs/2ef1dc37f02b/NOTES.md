# Reproducer notes

`repro.py` calls `_sre.template("", template)` twice, with an invalid group
index in the template list: first `-1` (a negative int), then `()` (not an
int at all). This mirrors
`test.test_re.ImplementationTest.test_sre_template_invalid_group_index`.

- `python-clean`: both calls raise `TypeError`, with messages `invalid
  template` and `an integer is required` respectively. The script prints
  both messages and exits 0.
- `python-buggy` (with `injection.patch` applied, removing the
  `Py_SET_SIZE(self, i)` calls before the early-return/`goto bad_template`
  paths in `_sre_template_impl`): the partially-initialized template object
  still reports its full intended size, so when it is deallocated the
  destructor iterates over uninitialized `self->items[i].index`/`.literal`
  entries and dereferences garbage, crashing the process (observed as exit
  status -11, SIGSEGV) instead of raising `TypeError`.

`./check.sh` confirms: python-clean exits 0 and prints the two messages;
python-buggy exits with status -11 (segfault) and no output.
