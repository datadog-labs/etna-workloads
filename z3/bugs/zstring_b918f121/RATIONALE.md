Changed hunk: src/src/util/zstring.cpp, zstring::encode().
Traces to the single implementation hunk of FIX.diff (removal of `|| ch == '\\'` from the escape condition).
In this release the condition was `ch >= 127 || ('\\' == ch && next is 'u')`; I restored the unconditional `ch == '\\'` escape, so a plain '\' is again encoded as \u{5c} and fails the printable-ASCII roundtrip.

check.sh output: BUILD OK; FAIL zstring (rc=114) "Failed to roundtrip printable ASCII char: \" ASSERTION VIOLATION at test/zstring.cpp:19.
