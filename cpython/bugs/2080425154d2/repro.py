import pydoc, io
pydoc.pager = lambda text, title='': print('PAGER CALLED:', title)
buf = io.StringIO()
pydoc.Helper(output=buf).showtopic('with')
print('The "with" statement' in buf.getvalue())
