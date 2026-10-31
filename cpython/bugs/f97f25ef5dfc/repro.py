import email
src = (b'MIME-Version: 1.0\nContent-type: text/plain; charset="us-ascii"\n'
       b'Content-Transfer-Encoding: 8bit\n\nF\xf6\xf6 b\xe4r\n')
msg = email.message_from_bytes(src)
try:
    print(repr(msg.as_string()))
except Exception as e:
    print(type(e).__name__, e)
