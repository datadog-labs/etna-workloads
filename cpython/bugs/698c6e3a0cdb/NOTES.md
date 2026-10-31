Creates a zipapp from a dir whose target (`target.pyz`) lies inside the source dir, with a filter excluding `*.pyz`.
Clean: archive is created, prints `['__main__.py']`.
Buggy: the overwrite check runs on the unfiltered file list, so it raises ZipAppError.
