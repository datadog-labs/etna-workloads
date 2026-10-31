import random, sys
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.generator import Generator
import io

token = 12345
random.randrange = lambda *a, **k: token
boundary = Generator._make_boundary(text=None)
msg = MIMEMultipart()
msg.attach(MIMEText("before\n--" + boundary + "\nafter\n"))
Generator(io.StringIO()).flatten(msg, linesep="\r\n")
print(msg.get_boundary() == boundary + ".0")
