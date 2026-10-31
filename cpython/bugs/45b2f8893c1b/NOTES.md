Flattens an EmailMessage with a non-ASCII display name using BytesGenerator and policy.SMTP (linesep "\r\n").
The buggy interpreter strips only one char of the 2-char linesep when refolding the encoded word, so the From header comes out wrong (stray "\r" / altered folding); the clean one gives `From: =?utf-8?q?P=C3=A1olo?= <foo@bar.com>`.
