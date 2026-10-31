import email
src = ('MIME-Version: 1.0\n'
       'Content-type: text/plain; charset="iso-8859-1"\n'
       '\n'
       'F\xf6\xf6 b\xe4r\n').encode('iso-8859-1')
msg = email.message_from_bytes(src)
try:
    print(repr(msg.as_string()))
except Exception as e:
    print(type(e).__name__, e)
