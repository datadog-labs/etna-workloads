# Rationale

## Lib/mimetypes.py, `MimeTypes.guess_type`
Reverses the single implementation hunk of the fix. The fix replaced
`scheme, url = urllib.parse._splittype(url)` with `urllib.parse.urlparse(url)`
(using `p.scheme`/`p.path`). In v3.15.2 that code is
`p = urlparse(url); if p.scheme and len(p.scheme) > 1: ... else: return self.guess_file_type(...)`.
I restored `_splittype` (scheme is None -> fall through to `guess_file_type`,
which is the current equivalent of the old no-scheme path). With `_splittype`
the "rest" of the URL is not split into host/path/query/fragment, so:

* `http://host.html` -> rest `//host.html` has extension `.html` (host treated as file)
* `http://example.com/host.html#x.tar` / `?q=x.tar` -> fragment/query pollute the extension.

## Failing oracle cases
* `test_mimetypes.MimeTypesClassTestCase.test_url` fails (host-only URL gives text/html instead of (None, None)).
* test_urllib2 cases also fail (e.g. FTP/data handling expectations such as `image/gif` for `baz.gif;type=a`).
