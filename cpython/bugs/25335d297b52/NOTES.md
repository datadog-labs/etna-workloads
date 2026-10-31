Sets a memoryview payload with Content-Transfer-Encoding quoted-printable and calls get_payload(decode=True).
Clean: prints b'Some payload'. Buggy: UnboundLocalError (bpayload unset for non-str/bytes payloads).
