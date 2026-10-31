import urllib.request
for url in ('data:text/html;\x01,data', 'data:text/html\x7f;base64,ZGF0YQ=='):
    try:
        with urllib.request.urlopen(url) as r:
            print(repr(r.info().get_content_type()), r.read())
    except ValueError as e:
        print('ValueError', e)
