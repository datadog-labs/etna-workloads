import _interpreters
script = "import _testsinglephase\nprint(_testsinglephase)\n"
i = _interpreters.create()
for _ in range(2):
    exc = _interpreters.run_string(i, script)
    print(exc.type.__name__ if exc else None)
_interpreters.destroy(i)
