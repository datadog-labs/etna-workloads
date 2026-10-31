import token
from io import StringIO
from tokenize import generate_tokens
for src in ["2sin(x)", "01234"]:
    try:
        for t in generate_tokens(StringIO(src).readline):
            print(token.tok_name[t.type], repr(t.string), t.start, t.end)
    except Exception as e:
        print(type(e).__name__, e)
