Registers a custom archiver with supports_root_dir=True and calls shutil.make_archive with
path-like base_name, root_dir and base_dir. Clean: all are converted with os.fspath, so the
archiver receives plain strings and the script prints True. Buggy: base_dir (and root_dir)
are passed through unconverted, so the archiver receives path-like objects and it prints False.
