# Rationale
Reverses the fix's removal of `if not data: return` in `_ProactorDatagramTransport.sendto` (proactor_events.py) and `_SelectorDatagramTransport.sendto` (selector_events.py), so empty datagrams are silently dropped again. The `+ 8` header accounting is now the `_header_size` attribute and stays consistent with its decrement sites, so it is left untouched.
Oracle failures: test_sendto_no_data and test_sendto_buffer_nodata in both test_proactor_events and test_selector_events (sendto not called / empty datagram not buffered).
