import sys
sys.modules.pop('stat', None)
sys.modules['_stat'] = None
import stat
print(repr(stat.filemode(stat.S_IFSOCK | 0o755)))
