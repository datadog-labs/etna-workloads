Reads a config with a multiline value followed by a duplicate option, catches DuplicateOptionError, then reads the value.
Clean: prints '1\n2' (multiline values still joined). Buggy: _join_multiline_values is skipped, so the value is still a list and get() raises AttributeError.
