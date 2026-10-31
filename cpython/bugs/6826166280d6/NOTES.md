Calls warnings.warn_explicit with a filename like 'a/b/pkg/mod.py' (module derived from filename)
and a filter module regex r'pkg\.mod\z'. Clean: the filename is converted to a dotted name and matched
at each component, so the filter matches and the warnings are recorded. Buggy: only the raw
filename (minus .py) is matched, so the warnings are not recorded and 'error' filter raises UserWarning.
