import io, tokenize
src = "f'''\n    🔗 This is a test {test_arg1}🔗\n🔗'''"
for t in tokenize.generate_tokens(io.StringIO(src).readline):
    print(tokenize.tok_name[t.type], repr(t.string), t.start, t.end)
