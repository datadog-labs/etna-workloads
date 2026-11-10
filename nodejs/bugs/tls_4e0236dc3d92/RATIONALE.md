# Bug
`tls.TLSSocket#getEphemeralKeyInfo()` returned an object with all fields undefined whenever OpenSSL has no
recognizable peer temporary key (e.g. TLS 1.3 PQ/hybrid groups such as X25519MLKEM768). Before the fix there
was no fallback to the negotiated TLS Supported Group name, so `type: 'TLSGroup'` was never reported.

# Change
- `src/crypto/crypto_common.cc` (GetEphemeralKey): removed the `bool found` tracking and the
  `if (!found) { ssl.getNegotiatedGroup() -> values[0]=tls_group_string, values[1]=name }` fallback. This
  corresponds to the fix's hunks adding `found` and the fallback; the DH/ECDH paths are unchanged
  (today's code uses KeyAlgorithm rather than a switch, so the hunk is re-expressed).
- `src/env_properties.h`: the fix's `tls_group_string` hunk was not reverted (property left in place, unused), as it is harmless and
  avoids a layout change.

# Failing test
`parallel/test-tls-client-getephemeralkeyinfo` fails (TLS 1.3 group test, line 156):
`AssertionError: Expected values to be strictly equal: undefined !== 'TLSGroup'`.
