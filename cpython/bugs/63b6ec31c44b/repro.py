import io, pdb

def foo():
    x = 40 + 2
    pdb.Pdb(skip=['__main__'], stdin=io.StringIO("p x\nc\n"), stdout=out).set_trace()
    return x

out = io.StringIO()
foo()
print("42" in out.getvalue())
