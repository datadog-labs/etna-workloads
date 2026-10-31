import io
from email.message import EmailMessage
from email.generator import BytesGenerator

msg = EmailMessage()
msg['Subject'] = " Уведомление"
s = io.BytesIO()
BytesGenerator(s).flatten(msg)
print(repr(s.getvalue()))
