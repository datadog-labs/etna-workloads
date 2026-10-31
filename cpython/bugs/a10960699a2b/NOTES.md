repro.py imports `_datetime` concurrently from 8 subinterpreters (InterpreterPoolExecutor), without importing it in the main interpreter first.
Clean: prints `aaaaaaaa`, exit 0. Buggy: static types are initialized lazily at module load, racing across interpreters; it crashes (exit -11, memory corruption report) every run tried.
