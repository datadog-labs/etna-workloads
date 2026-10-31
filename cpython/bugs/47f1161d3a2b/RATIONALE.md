# Rationale

Fix hunks reversed, all in `Lib/ipaddress.py` `_BaseV6._ip_int_from_string`:

1. Length guard (`len(ip_str) > 39` in the fix). v3.15.2 has the later form of
   the same guard (`> 45`, with a longer elision message). I removed it, so
   long strings are no longer rejected up front.
2. `ip_str.split(':', maxsplit=_max_parts)` goes back to an unbounded
   `ip_str.split(':')`, with `_max_parts` defined later, just before the
   "At most %d colons" check, as it was before the fix. Long inputs again
   produce a huge list before any check runs (the DoS the fix addressed).

Oracle: `AddressTestCase_v6.test_bad_address_split_v6_too_long` fails. The
10000-colon address now raises "At most 8 colons permitted" instead of
"At most N characters expected".
