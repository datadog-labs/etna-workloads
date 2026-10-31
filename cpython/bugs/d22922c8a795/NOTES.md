Calls webbrowser.Chrome.open() with '%action--incognito' and with '%action' (new=1).
Fixed: both raise ValueError, since the URL is checked after %action expansion.
Buggy: the check runs on the unexpanded URL, so no ValueError is raised (open proceeds to invoke the browser).
