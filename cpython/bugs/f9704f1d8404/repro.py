import os, pydoc, encodings, importlib._bootstrap
from unittest import mock
md = {'encodings': 'codecs#module-encodings'}
with mock.patch('pydoc_data.module_docs.module_docs', md):
    doc = pydoc.TextDoc()
    basedir = os.path.dirname(encodings.__file__)
    print(repr(doc.getdocloc(encodings, basedir=basedir)))
    print(repr(doc.getdocloc(importlib._bootstrap, basedir=basedir)))
