repro.sql creates a view whose compound SELECT has an ORDER BY term that fails to resolve, then runs ALTER TABLE RENAME.
Clean: "error in view c: 1st ORDER BY term does not match any column in the result set" (exit 1).
Buggy: errors are suppressed while resolving the ORDER BY term during rename, so the shell aborts on assertion `p->selFlags & SF_Resolved` in selectAddSubqueryTypeInfo.
