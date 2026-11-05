# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f7a191f5377dacd05d22dd40c1d1e38b393ea9b4 ("Fix unbounded recursive handling of SSL/GSS in ProcessStartupPacket()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/tcop/backend_startup.c

Failing oracle cases:
- `src/test/postmaster|t/004_negotiate.pl|server able to accept connection`
- `src/test/postmaster|t/004_negotiate.pl|server does not re-enter SSL negotiation after SSL+GSS were both tried`
