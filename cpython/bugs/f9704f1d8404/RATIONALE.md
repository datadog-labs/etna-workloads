# Rationale

Hunk reversed: `Lib/pydoc.py` `getdocloc` (fix hunk @@ -483,10 +483,20).
The fix replaced the guessed link `<module name lowercased>.html` with a lookup in
`pydoc_data.module_docs` (returning None when the module is unlisted). I restored the
old code: the link is always `docloc/<name.lower()>.html` (URL or os.path.join form), with no lookup.
The generated module_docs.py and Doc/ tooling hunks are data/build and left alone.

Oracle failure: `PydocDocTest.test_online_docs_link` fails. Links come out as
`encodings.html` and `encodings.idna.html` instead of `codecs#module-encodings...`, and
`importlib._bootstrap` gets a link instead of None.
