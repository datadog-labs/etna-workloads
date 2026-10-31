Calls email._encoded_words.decode on an encoded word whose charset contains lone surrogates.
Clean: the charset lookup fails with UnicodeEncodeError, which is handled, so decode returns a result with a CharsetError defect.
Buggy: UnicodeEncodeError is no longer caught, so it propagates as an uncaught exception.
