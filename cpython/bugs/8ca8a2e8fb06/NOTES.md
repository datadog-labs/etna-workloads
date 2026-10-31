Calls HTTPConnection.request() with methods containing control characters (CR/LF).
Clean: raises ValueError "method can't contain control characters". Buggy: the method is accepted (header injection possible).
