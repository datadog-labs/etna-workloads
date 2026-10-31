Parses a message whose Content-Transfer-Encoding is "base64 " / "base64 some text" and prints get_payload(decode=True), under the default and compat32 policies.
Clean: b'Hello. Testing' (compat32 with extra text is not decoded in either build). Buggy: the CTE is not stripped / `.cte` attribute is not used, so the payload is returned undecoded.
