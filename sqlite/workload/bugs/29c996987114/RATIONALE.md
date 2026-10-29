# Rationale

Fix: json_patch() failed to strip NULL members from nested objects of the patch
(added `jsonRemoveAllNulls()`, called when a new key is appended).

In 3.54.1 (JSONB `jsonMergePatch()` in src/json.c) the nested-null removal
happens by recursion: when the patch key is absent from the target and the
patch value is an object, the code appends an empty object and recurses
(`MergePatch('{}', value)`, algorithm line 17), which drops null members.

Change: in that "no match, value not NULL" branch (algorithm lines 13-17) I
removed the object special case, so every patch value, including objects, is
copied verbatim into the target. This is equivalent to the pre-fix behaviour
where the patch subtree was appended without removing the nested NULLs.

Failing oracle cases (test/json104.test):
- json104-220: `json_patch('{}','{"a":{"bb":{"ccc":null}}}')` gives
  `{"a":{"bb":{"ccc":null}}}` instead of `{"a":{"bb":{}}}`.
- json104-314: same defect, with the same input and expected output.
