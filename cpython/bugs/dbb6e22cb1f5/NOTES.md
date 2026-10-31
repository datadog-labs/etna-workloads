Calls urljoin() with scheme-less (relative) base URIs, e.g. urljoin('//a', 'w').
Clean returns '//a/w' (and '/b/w' for base '/b/c'); buggy returns 'w' because an
empty scheme is treated as not in uses_relative, so the url is returned unchanged.
