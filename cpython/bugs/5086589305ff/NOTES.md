repro.py calls pyclbr.readmodule_ex('doesnotexist') and prints the exception.
Clean: ModuleNotFoundError "no module named 'doesnotexist'".
Buggy: AttributeError ('NoneType' has no attribute 'submodule_search_locations'), because the missing-spec check was removed.
