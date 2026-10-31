import smtplib
from email.message import EmailMessage
from email.utils import formataddr

class S(smtplib.SMTP):
    def ehlo_or_helo_if_needed(self):
        pass
    has_extn = lambda self, n: False
    def sendmail(self, from_addr, to_addrs, msg, *a, **k):
        print(repr(from_addr), repr(to_addrs))
        return {}

m = EmailMessage()
m['From'] = formataddr(('Michaël', 'michael@example.com'))
m['To'] = formataddr(('René', 'rene@example.com'))
S().send_message(m)
