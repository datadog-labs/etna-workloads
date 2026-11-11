"""Compat shim for old rust bootstraps under Python >= 3.12 (distutils was removed).

Bootstraps before rust-lang/rust 385dbff9e5a (2023-01-30) still `import distutils.version`
but no longer use it.  anchor.py puts this directory on PYTHONPATH only for trees where
the import is present and unused, and records that in the anchor result.  Any real use
fails loudly instead of silently behaving differently from the original module.
"""
