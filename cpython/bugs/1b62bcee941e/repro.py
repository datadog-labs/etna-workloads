import io, tokenize
src = "a = f'''\n    Autorzy, którzy tą jednostkę mają wpisani jako AKTUALNA -- czyli'''"
for t in tokenize.generate_tokens(io.StringIO(src).readline):
    print(tokenize.tok_name[t.type], repr(t.string), t.start, t.end)
