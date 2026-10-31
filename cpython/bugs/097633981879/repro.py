from email import message_from_string, policy
import email.errors

class LiteralHeader(str):
    name = 'Header'
    def fold(self, **kwargs):
        return self

for text in ('Value\r\nBad Injection\r\n', 'NoNewLine'):
    m = message_from_string("Header: Value\r\n\r\nBody", policy=policy.default)
    del m['Header']
    m['Header'] = LiteralHeader(text)
    try:
        print(repr(m.as_string()))
    except email.errors.HeaderWriteError as e:
        print('HeaderWriteError', e)
