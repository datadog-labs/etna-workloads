from test import support
script = '''if True:
    import _testinternalcapi
    _testinternalcapi.gh_119213_getargs(spam='eggs')
    '''
config = dict(
    allow_fork=False,
    allow_exec=False,
    allow_threads=True,
    allow_daemon_threads=False,
    use_main_obmalloc=False,
    gil=2,
    check_multi_interp_extensions=True,
)
rc = support.run_in_subinterp_with_config(script, **config)
print(rc)
