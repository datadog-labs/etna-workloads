Input: an async loop where `const results = await get_things(before)` and `before = results[0]` feed back into the call argument (CFA loop, strict mode).
Clean: no diagnostics. Injected: spurious TS7022 "'results' implicitly has type 'any' ... referenced directly or indirectly in its own initializer".
Cause: the injected build no longer quick-types `await` expressions, so the circularity is hit.
