Writes a tar (GNU and PAX formats) containing an AREGTYPE member with a >100-char name
(forcing a long-name header), then reads it back and prints the member types.
Clean: type stays b'\x00'. Buggy: the follow-up header after a GNU long name / PAX header is
normalized to DIRTYPE wrongly (b'5'), because the dircheck skip is missing.
