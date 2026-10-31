# RATIONALE

Fix gh-124594 made the asyncio REPL use one shared context. v3.15.2's `Lib/asyncio/__main__.py` has the same code in `AsyncIOInteractiveConsole`, so the fix hunks reverse directly:

- Removed `import contextvars` and `self.context = contextvars.copy_context()` in `__init__`.
- `create_task(coro, context=self.context)` -> `create_task(coro)`.
- `call_soon_threadsafe(callback, context=self.context)` -> `call_soon_threadsafe(callback)`.

Each REPL statement therefore runs in a fresh context copy again, so ContextVar changes don't persist between prompts.

Failing oracle cases: `TestAsyncioREPL.test_toplevel_contextvars_sync` and `test_toplevel_contextvars_async`. Both print `failed` (the default) instead of `ok`.
