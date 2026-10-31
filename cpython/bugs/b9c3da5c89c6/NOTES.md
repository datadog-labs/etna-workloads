Calls pkgutil.walk_packages with a str path and a bytes path.
Clean: raises ValueError (str) / TypeError (bytes). Buggy: str path silently returns [] (no ValueError).
