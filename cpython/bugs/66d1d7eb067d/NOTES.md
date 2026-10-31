Loads tests from unittest.FunctionTestCase directly and from a module that merely imports TestCase/FunctionTestCase.
Clean: prints `[]` twice. Buggy: the base classes are loaded (FunctionTestCase gets a `runTest` instance, shown in the output as a non-empty list/suite).
