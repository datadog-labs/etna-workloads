Reproducer for bpo-34155 (addresses with two `@`). It calls `_header_value_parser.get_addr_spec` on
`star@a@example.com` etc. and `email.utils.parseaddr('a@malicious.org@important.com')`.
Clean: HeaderParseError('Invalid Domain') and `('', '')`. Buggy: addr_spec parses without error and
parseaddr returns a partial/incorrect address.
