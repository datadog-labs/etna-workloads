import io, tokenize
src = "); x"
for t in tokenize.generate_tokens(io.StringIO(src).readline):
    print(t.type, repr(t.string), t.start, t.end)
