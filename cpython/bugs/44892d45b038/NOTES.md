Saves a cookie jar with one cookie, clears it, saves again, then reloads.
Clean: the file is truncated, so 0 cookies load. Buggy: save() omits O_TRUNC,
so stale cookie data remains and 1 cookie is loaded (for both LWP and Mozilla jars).
