Marshals self-referential code, slice and frozendict objects (as in the new test_reference_loop_* tests)
with every marshal version and prints whether ValueError is raised.
Clean: ValueError everywhere. Buggy: for version >= 3 (code), >= 5 (slice), 6 (frozendict) dumps
succeeds silently, producing data that cannot be unmarshalled correctly.
