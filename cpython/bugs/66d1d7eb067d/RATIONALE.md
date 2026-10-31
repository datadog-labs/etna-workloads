# Rationale

Reverts the three hunks of the fix in Lib/unittest/loader.py:
- loadTestsFromTestCase: removed the `testCaseClass in (TestCase, FunctionTestCase)` guard (the abstract-class guard added later is kept), so tests/runTest are loaded from the base classes again.
- loadTestsFromModule: removed `obj not in (TestCase, FunctionTestCase)`, so imported `TestCase`/`FunctionTestCase` names get loaded.
- loadTestsFromName: removed the same exclusion.

Failing oracle cases: test_loadTestsFromTestCase__from_TestCase and test_loadTestsFromTestCase__from_FunctionTestCase (the suite contains a FunctionTestCase/TestCase runTest instance instead of being empty).
