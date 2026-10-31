Parses `Content-Disposition: attachment; 0*00="foo"` via HeaderRegistry and prints defect types.
Clean: InvalidHeaderDefect. Buggy: the parser appends errors.InvalidHeaderError (an exception, not a defect), so the output/exception differs.
