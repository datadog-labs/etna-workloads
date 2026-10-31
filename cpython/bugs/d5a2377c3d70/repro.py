from http import cookies
c = cookies.SimpleCookie()
c['foo'] = '\N{COPYRIGHT SIGN}'
c['foo']['comment'] = 'comment \N{COPYRIGHT SIGN}'
print(str(c['foo']))
