Calls _pyrepl.readline._should_auto_indent on 'def f():  ## foo'. Clean: True; buggy: False (the '#' skip makes it treat '##' comment wrongly).
