Starts a Process from a spawn context without setting a global start method, then prints
`multiprocessing.get_start_method(allow_none=True)`. Clean: `None`. Buggy: `'forkserver'` (the platform default)
(get_preparation_data calls get_start_method() which sets the default globally).
