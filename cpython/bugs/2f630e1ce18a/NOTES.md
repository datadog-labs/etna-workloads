Calls urlsplit on a URL with leading C0 control/space chars (str and bytes).
Clean strips them (scheme='http', netloc parsed); buggy doesn't strip, so scheme is empty and the whole string lands in path.
