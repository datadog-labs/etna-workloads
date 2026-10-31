import email
m = (b"From: foo@bar.com\nContent-Type: text/plain; charset*=ansi-x3.4-1968''utf-8\n"
     b"Content-Transfer-Encoding: 8bit\n\np\xc3\xb6stal\n")
msg = email.message_from_bytes(m)
print(repr(msg.get_payload()))
