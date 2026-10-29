Creates an FTS3 table in a UTF-16le database and renames it. The buggy shell passes the
UTF-16 new name to the vtab xRename without converting to UTF-8, so the shadow tables
are renamed wrongly (or the rename fails). The clean shell lists xyz_content, xyz_segdir, xyz_segments.
