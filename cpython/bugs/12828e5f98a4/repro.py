import os, shutil, tempfile

class P:
    def __init__(self, p): self.p = p
    def __fspath__(self): return self.p

calls = []
def archiver(base_name, base_dir, **kw):
    calls.append((base_name, base_dir, kw.get('root_dir')))
archiver.supports_root_dir = True
shutil.register_archive_format('xxx', archiver, [], 'xxx file')

root = tempfile.mkdtemp()
try:
    shutil.make_archive(P('basename'), 'xxx', root_dir=P(root), base_dir=P('basedir'))
    print(calls == [('basename', 'basedir', root)])
except Exception as e:
    print(type(e).__name__, e)
