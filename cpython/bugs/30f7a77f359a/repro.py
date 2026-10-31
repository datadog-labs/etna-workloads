from email.message import EmailMessage
m = EmailMessage()
m.set_content('test')
del m['Content-Type'], m['Content-Transfer-Encoding'], m['MIME-Version']
m.set_unixfrom('From foo@bar Thu Jan  1 00:00:00 1970')
print(repr(m.as_string(unixfrom=True)))
print(repr(m.as_string(unixfrom=False)))
