from email.message import EmailMessage
m = EmailMessage()
m.add_header('Content-Transfer-Encoding', 'quoted-printable')
m.set_payload(memoryview(b'Some payload'))
print(repr(m.get_payload(decode=True)))
