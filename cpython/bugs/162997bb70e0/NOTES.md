repro.py builds a small in-memory zip with a Zip64 end-of-central-directory record
(with a corrupt record size, with "zip64 extensible data", and the latter with
prepended bytes) and prints the result of ZipFile.read plus is_zipfile.

Clean: the corrupt record raises BadZipFile "Corrupt zip64 ... record", extensible
data is read fine, and prepended data raises "record not found"; is_zipfile returns
False for the invalid ones. Buggy: the consistency checks are gone, so the extensible-data
archive fails to open, and the corrupt/prepended cases give different results.
