import tokenize
from io import BytesIO
for src in ('a\n ', 'b = 1\n\n#test'):
    for t in tokenize.tokenize(BytesIO(src.encode()).readline):
        print(t)
