import poplib
p = poplib.POP3.__new__(poplib.POP3)
p._debugging = 0
p.encoding = 'utf-8'
p._putline = lambda line: print('sent', repr(line))
for cmd in ('USER user\r\nDELE 1', 'PASS \x00pass'):
    try:
        p._putcmd(cmd)
    except ValueError as e:
        print('ValueError', e)
