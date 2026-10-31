Parses a valid multipart message with `Parser.parsestr(..., headersonly=True)` and prints `msg.defects`.
Clean: `[]`. Buggy: `[MultipartInvariantViolationDefect()]`, because FeedParser.close() flags the
unparsed body as an invariant violation even when only headers were requested.
