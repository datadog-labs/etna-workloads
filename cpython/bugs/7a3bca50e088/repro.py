from _pyrepl.utils import gen_colors
for src in ["a.set", "obj.list", "b. \\\n format", "set"]:
    print(repr(src), [(src[c.span.start.col:c.span.end.col + 1] if False else c.tag) for c in gen_colors(src)])
