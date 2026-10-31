# Rationale

Fix gh-114763 added a lock/`is_loading` flag and moved the `self.__class__ = types.ModuleType`
reset from the start of `_LazyModule.__getattribute__` to the end, after `exec_module()`.
In v3.15.2 the lock and reentrancy guard already exist, and the class reset is at the end
(`object.__setattr__(self, '__class__', __class__)`, guarded by `isinstance`).

Change (Lib/importlib/util.py, `_LazyModule.__getattribute__`): reset the class to the
original one immediately after setting `is_loading`, before the load, and drop the reset at
the end. This reverses the fix hunk that moved "Finally, stop triggering this method" after loading.
Other threads that read the class without taking the lock then see a plain module while
`exec_module()` is still running, and access attributes of a half-loaded module.

Oracle failure: `LazyLoaderTests.test_module_load_race` fails with
`AttributeError: module 'lazy_loader_test' has no attribute 'attr'` in a racing thread.
The other 14 cases pass.
