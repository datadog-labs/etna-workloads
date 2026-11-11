Uses include_str! (via #![doc]) with an absolute path to a small binary file ("MZ\x90\x00
") that is invalid UTF-8. The clean compiler reports "wasn't a utf-8 file" and exits 1; the injected compiler (missing the out-of-bounds span guard after lossy conversion) panics in annotate-snippets (ICE, exit 101).
