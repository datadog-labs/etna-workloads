import io, os, pydoc
from contextlib import redirect_stdout

inputs = iter(["", "    ", "quit"])
output = io.StringIO()

def getline(prompt):
    output.write(prompt)
    s = next(inputs)
    output.write(s + os.linesep)
    return s

helper = pydoc.Helper(output=output)
helper.getline = getline
helper.interact()
print(output.getvalue().strip().splitlines())
