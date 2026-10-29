repro.sql quotes a string containing a non-ASCII char (ä, UTF-8 bytes >0x7f) via unistr_quote() and format('%#Q').
Clean: 'Gäste'. Buggy: the high bytes are treated as signed chars <=0x1f, so they are mis-escaped as \uXXXX control characters.
