Writes a plist with `_PlistWriter(indent=b'\t   ')` containing 50 bytes and prints the XML.
The buggy interpreter computes the Base64 line width by replacing tabs with 8 spaces, which is wrong for mixed tabs and spaces. The Base64 lines wrap at a different width than on the clean interpreter.
