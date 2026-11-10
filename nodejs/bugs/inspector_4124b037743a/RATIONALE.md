# Re-introduced bug: CVE-2022-43548 (inspector Host IP validation)

**Bug.** `IsIPAddress()` in `src/inspector_socket.cc` used a hand-written parser instead of `inet_pton()`. It accepted ambiguous IPv4 forms (leading zeros or octal-looking octets such as `1.09.1.1`, `1.1.001.1`, `1.1.1.009`). Any bracketed string was accepted as IPv6, including `[::]`, `[::0.0.0.0]`, `[127.0.0.1]` and `[:::1]`. This allows DNS-rebinding bypasses of the Host header check.

**Hunk (single).** The new `IsIPAddress` body (null-byte check, `uv_inet_pton` for IPv6 and IPv4, `%` rejection, `::/128` and `0.0.0.0/8` rejection) is replaced with the pre-fix hand-written parser. This matches the fix's one hunk in `src/inspector_socket.cc`, re-expressed against today's code, which differs from the original only in comments and `std::ranges`. The parser has a bracket shortcut, a `front()=='0'` rejection and a decimal-accumulator octet loop.

**Failing tests** (each hits the 5 s timeout; the failure is at test_inspector_socket.cc:323, because the handshake succeeded instead of failing):
HostIpInvalidOctalOctetMidChecked, HostIpInvalidOctalOctetEndChecked, HostIpLeadingZeroMidChecked, HostIpLeadingZeroEndChecked, HostIPv6NonRoutable, HostIPv6NonRoutableDual, HostIPv4InSquareBrackets, HostIPv6InvalidAbbreviation.

The `...OctalOctetStart` and `...LeadingZeroStart` cases still pass because the old `front()=='0'` check rejects them. I ran only `InspectorSocketTest.Host*` with cctest. I did not run `tools/test.py`, so the full JS suite has not been run.
