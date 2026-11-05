#!/bin/sh
# Reproducer for the SSL/GSS negotiation recursion bug fixed by
# f7a191f5377d ("Fix unbounded recursive handling of SSL/GSS in
# ProcessStartupPacket()").
#
# We send SSLRequest, then GSSENCRequest (both rejected with 'N' since the
# server builds used here have neither compiled in), and then a second
# SSLRequest. On a fixed server, the second SSLRequest is not treated as a
# fresh negotiation attempt (ssl_done/gss_done are tracked across the
# recursive/looped calls), so it is rejected outright and the connection is
# closed without another 'N' reply. On the buggy server, the tracking is
# lost and it re-enters SSL negotiation, replying 'N' again.
set -eu
cd "$(dirname "$0")"
python3 -I repro_negotiate.py
