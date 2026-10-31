import io, pydoc
for src in ['"Single double quotes"', "'''Triple single quotes'''", 'import sys\n"""No docstring"""', '"""Embedded null byte"""\0']:
    print(repr(pydoc.source_synopsis(io.StringIO(src))))
