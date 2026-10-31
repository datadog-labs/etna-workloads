Constructs http.client.HTTPConnection with a host containing CR/LF (header injection, CVE-2019-18348).
Clean: raises InvalidURL ("URL can't contain control characters ..."). Buggy: the host is accepted silently
(prints "accepted ...") because the _validate_host call in HTTPConnection.__init__ was removed.
