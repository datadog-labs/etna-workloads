from _pyrepl.utils import gen_colors
code = "def unfinished_function():\n    var = 1\n   oops\n"
print([(c.span, c.tag) for c in gen_colors(code)])
