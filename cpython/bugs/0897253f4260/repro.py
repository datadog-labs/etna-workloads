import smtplib

class S(smtplib.SMTP):
    def send(self, s):
        print(repr(s))

c = S()
try:
    c.putcmd("helo", "a\r\nX: y")
except ValueError as e:
    print("ValueError", e)
