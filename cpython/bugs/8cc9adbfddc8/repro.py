from email.policy import default
from email.message import EmailMessage
for h in ['.foo <a@b.com>', 'foo. <a@b.com>', 'foo.<a@b.com>']:
    m = EmailMessage(policy=default)
    try:
        m['To'] = h
        print(repr(str(m['To'])), [a.display_name for a in m['To'].addresses])
    except Exception as e:
        print(type(e).__name__, e)
