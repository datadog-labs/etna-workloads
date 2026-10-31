Prints `platform.uname()._fields` and `len(uname()._asdict())`.
Clean: six fields including 'processor', asdict length 6.
Buggy: 'processor' missing from `_fields`, asdict length 5.
