Sets sys.prefix/sys.exec_prefix to fake values, then prints sysconfig config vars prefix/exec_prefix/base/platbase.
Clean: they reflect the fake values. Buggy: prefix/exec_prefix come from the Makefile data (real install prefix) instead.
