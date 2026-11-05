# Rationale

File: src/backend/replication/logical/slotsync.c, function update_local_synced_slot().
Traces to the fix.patch hunks in slotsync.c that sync `two_phase_at`: the
`remote_slot->two_phase_at != slot->data.two_phase_at` condition and the
`slot->data.two_phase_at = remote_slot->two_phase_at` assignment. Both are removed.
The synced slot on the standby never receives the primary's two_phase_at, so a
two_phase-enabled slot is synced with two_phase_at = 0 (and a change in it doesn't trigger a
config update). After promotion, prepared transactions can be decoded incorrectly or lost.

Failing oracle cases: 4 of 36 fail; the one I could identify is below (the other three were cut off by my output filtering):
- two_phase setting of slot lsub1_slot synced to standby
