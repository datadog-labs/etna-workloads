import urllib.parse
for u in ['Scheme://user@[192.0.2.146]/Path?Query',
          'scheme://prefix.[::1]/',
          'scheme://[::1].suffix',
          'Scheme://user@[v12ae]/Path?Query']:
    try:
        print(repr(urllib.parse.urlsplit(u)))
    except ValueError as e:
        print('ValueError', e)
