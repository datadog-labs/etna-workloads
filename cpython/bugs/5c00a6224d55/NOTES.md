Sets the global `http.client.HTTPConnection.debuglevel` / `HTTPSConnection.debuglevel` and
creates default `HTTPHandler` / `HTTPSHandler`. Clean prints 5 and 4 (handlers honor the global
debuglevel); buggy prints 0 and 0 (default argument is hardcoded to 0).
