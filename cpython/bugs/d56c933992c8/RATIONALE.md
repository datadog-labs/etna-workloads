# Rationale

Fix: gh-104770 made `generator.close()` return the value a generator returns
after catching GeneratorExit (previously the StopIteration was cleared and
`None` returned).

Changed hunk (Objects/genobject.c, `gen_close`): in v3.15.2 the fix's logic
lives in the `gen_send_ex2(...) == PYGEN_RETURN` branch. It used to
`return retval;`; it now discards `retval` and returns `None`. This is
equivalent to the pre-fix behaviour, which ignored StopIteration (the return
value) and returned `None`.

Failing oracle cases: `GeneratorCloseTest.test_close_return_value` and
`test_close_closed` (`gen.close()` gives `None` instead of `0`).
