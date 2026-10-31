import io
from email.message import EmailMessage
from email.generator import Generator
from email import policy

msg = EmailMessage()
msg['To'] = 'wők@example.com'
s = io.StringIO()
try:
    Generator(s, policy=policy.default.clone(utf8=False, max_line_length=20)).flatten(msg)
    print(repr(s.getvalue()))
except Exception as e:
    print(type(e).__name__, e)
