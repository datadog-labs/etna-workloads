from email import message_from_bytes, policy
from email.message import EmailMessage

m = EmailMessage(policy.default)
m['Message-ID'] = '123456789' * 10
data = m.as_bytes()
print(repr(data))
print(repr(message_from_bytes(data, policy=policy.default)['Message-ID']))
