Reproducer: folds a non-ASCII Subject ('á') with the default (non-utf8) policy via `Policy.fold`.
Clean: `'Subject: =?utf-8?q?=C3=A1?=\n'` (RFC 2047 encoded). Buggy: the non-ASCII value is no longer refolded, so the raw `'Subject: á\n'` is returned.
