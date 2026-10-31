repro.py moves a symlink-to-dir into the directory it points to. Clean: link moves into dst. Buggy: _samefile branch does os.rename(link, dst) and raises OSError.
