Copies an HMAC (via `hmac.new` and `_hashlib.hmac_new`) and compares name, digest_size and block_size between original and copy.
Clean: prints `True True True` twice. Buggy: the copy loses evp_md_nid / block_size, so the interpreter aborts with an assertion failure in `get_asn1_utf8name_by_nid` (exit -6).
