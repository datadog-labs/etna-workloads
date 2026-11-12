# buffer_pool_reservation_move_assignment_578550b4e2

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 578550b4e2334fc2936c4d1d1f6199eb9e89afe3 ("Fix buffer pool reservation for move assignment"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_buffer_pool_reservation.cpp::BufferPoolReservation move assignment releases old reservation
