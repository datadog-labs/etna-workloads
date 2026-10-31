Folds a 90-char unbreakable Message-ID with policy.default (the value goes on the line after "Message-ID:"), then re-parses the bytes.
Clean: the parsed value equals the original. Buggy: header_source_parse keeps the leading space, so the parsed value starts with a space.
