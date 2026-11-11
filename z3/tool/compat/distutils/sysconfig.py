import sysconfig as _sc
import sys as _sys


def get_python_lib(plat_specific=0, standard_lib=0, prefix=None):
    vars = {"base": prefix, "platbase": prefix} if prefix else None
    key = "stdlib" if standard_lib else ("platlib" if plat_specific else "purelib")
    return _sc.get_paths(vars=vars)[key]


def get_python_version():
    return "%d.%d" % _sys.version_info[:2]


def get_config_var(name):
    return _sc.get_config_var(name)
