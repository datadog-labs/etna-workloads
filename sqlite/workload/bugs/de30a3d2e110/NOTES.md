`repro.sql` calls the regexp extension's `regexp('ABC.','ABC')` and `regexpi('ABC.','ABC')`.
The pattern needs a character after "ABC", but the input has none. Clean prints 0 for both.
The buggy shell lets "." match the 0x00 terminator, so it prints 1.
