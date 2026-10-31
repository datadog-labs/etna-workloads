from urllib.parse import urljoin
for base, url in [('//a', 'w'), ('//', '/w'), ('/b/c', 'w'), ('', 'w'), ('//a', '//v')]:
    print(repr(base), repr(url), repr(urljoin(base, url)))
