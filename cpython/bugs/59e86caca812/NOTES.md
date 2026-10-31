Calls zipfile._Extra.strip on extra-field blobs containing a stripped ID (1) followed by other fields.
Clean: removes only the ID-1 fields and keeps the rest (b+c, b+c, b"z").
Buggy: stops at the first stripped field and drops all data after it (b'' / only the part before it).
