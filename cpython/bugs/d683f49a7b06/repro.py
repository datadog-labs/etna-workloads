from _pyrepl.readline import _should_auto_indent
s = "def f():  ## foo"
print(_should_auto_indent(list(s), len(s)))
