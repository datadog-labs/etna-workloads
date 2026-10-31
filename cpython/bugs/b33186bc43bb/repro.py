from email.message import EmailMessage
m = EmailMessage()
m.set_content(b'ASCII-only message.\n', maintype='application',
              subtype='octet-stream', cte='7bit')
print(str(m))
