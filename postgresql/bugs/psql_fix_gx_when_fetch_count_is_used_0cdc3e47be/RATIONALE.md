# Rationale

Changed hunk: src/src/bin/psql/common.c, ExecQueryAndProcessResults (chunked-results branch, FETCH_COUNT mode).
Traces to the fix.patch hunk in ExecQueryUsingCursor() that added `if (pset.g_expanded) my_popt.topt.expanded = 1;`.

In current code \gx sets expanded in pset.popt (saving the original in pset.gsavepopt), and the FETCH_COUNT path is the chunked-rows branch, which copies pset.popt into my_popt. The fix's logic was that the FETCH_COUNT print path honors the one-shot \gx expansion. The change reverts this: the chunked branch resets my_popt.topt.expanded to the saved pre-\gx value, so \gx output is not expanded when FETCH_COUNT is set.

Failing oracle case: src/test/regress||psql
