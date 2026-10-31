Compares two code objects whose co_name comparison raises (BadStr.__eq__).
Clean: RuntimeError propagates. Buggy: error (-1) treated as equal, so comparison continues and the debug build hits an assertion/SystemError instead of raising cleanly.
