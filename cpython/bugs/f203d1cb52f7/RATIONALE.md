# Rationale (gh-125017)

All changes are in `tree/Objects/funcobject.c`; v3.15.2 still contained the fixed code, so the fix was reversed by hand.

- `descriptor_get_wrapped_attribute` / `descriptor_set_wrapped_attribute`: reverse the first two fix hunks. They take the raw `dict` again and no longer call `PyObject_GenericGetDict(obj)`, which lazily creates the dict. The DECREFs added by the fix are removed with it. The delete path returns 0 after raising AttributeError, as it did before the fix.
- `cm_get/set___annotations__`, `cm_get/set___annotate__`, `sm_get/set___annotations__`, `sm_get/set___annotate__`: reverse the caller hunks. The getters pass `cm->cm_dict` / `sm->sm_dict`, and the setters cast `self` and pass the same field. That slot is NULL until something creates `__dict__`.

## Oracle failures
Reading `__annotations__` on a staticmethod or classmethod whose `__dict__` was never created passes a NULL dict to `PyDict_GetItemRef`. This crashes the interpreter, so the run is incomplete. 147 of 165 oracle cases in `test_descr` fail, including `test_classmethod_staticmethod_annotations` and `test_classmethod_without_dict_access`. The rest fail only because the crash aborts the run.
