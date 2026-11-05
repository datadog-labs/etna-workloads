# Rationale

File/function: src/backend/catalog/dependency.c, findDependentObjects().

Traces to the fix.patch hunks in findDependentObjects(). The fix applies the
"creating_extension / CurrentExtensionObject" exception at any recursion level,
inside the DEPENDENCY_EXTENSION case, before falling through to the INTERNAL
handling. I removed it from there. I put it back as the old "Exception 1b",
inside the `if (stack == NULL)` block, after the pendingObjects check. The
exception now applies only at the outermost recursion level.

Effect: when an extension member object is reached by recursion from another
object (e.g. the serial-sequence case) while an extension script is running,
the exception is not applied and the drop fails with a dependency error (bug #14434).

Failing oracle case: src/test/modules/test_extensions||test_extensions
