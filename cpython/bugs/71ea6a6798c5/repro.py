from _pyrepl.utils import gen_colors
code = 'f"a{{b}}c"\nf"{{"\n'
for c in gen_colors(code):
    print(c)
