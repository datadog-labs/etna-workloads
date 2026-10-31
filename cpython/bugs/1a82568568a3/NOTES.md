Sets sys.modules['zlib'] = None (zlib unavailable), stubs ensurepip._run_pip, and calls ensurepip.bootstrap().
Clean: raises ModuleNotFoundError ("ensurepip requires the standard library module 'zlib' ...") and pip is not run.
Buggy: no zlib check, so no exception and _run_pip is called.
