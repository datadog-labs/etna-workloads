import io, getpass
out = io.StringIO()
r = getpass._raw_input('Password: ', out, input=io.StringIO('end\x01start\n'), echo_char='*')
print(repr(r))
print(repr(out.getvalue()))
