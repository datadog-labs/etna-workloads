from email import policy
from email.message import EmailMessage
m = EmailMessage(policy=policy.default.clone(max_line_length=20))
m['Subject'] = 'thisisaverylonglineconsistingofasinglewordthatwontfit'
print(repr(m['Subject'].fold(policy=m.policy)))
