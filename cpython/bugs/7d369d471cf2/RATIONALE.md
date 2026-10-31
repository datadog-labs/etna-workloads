# Rationale

Bug: after `agen.aclose().throw(...)` / `agen.athrow(...).throw(...)` raised,
the awaitable was not marked closed, so it could be reused.

Changed `async_gen_athrow_throw` in Objects/genobject.c (two places):
- athrow mode (`o->agt_typ` set): in the `retval == NULL` branch, removed `o->agt_state = AWAITABLE_STATE_CLOSED;` (reverses the fix's added `agt_state = CLOSED` after unwrap_value).
- aclose mode: same removal in the `retval == NULL` branch (reverses the fix's second added block).
In v3.15.2 these blocks also reset `ag_running_async`; that line is kept.

Failing oracle cases (3 errors in test_asyncgen):
- test_async_gen_throw_same_aclose_coro_twice: second `throw` raises StopIteration instead of RuntimeError "cannot reuse...".
- test_async_gen_throw_custom_same_aclose_coro_twice and ..._athrow_coro_twice: the second throw re-raises MyException instead of RuntimeError.
