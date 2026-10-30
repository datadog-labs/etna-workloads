Starts two cluster-enabled nodes, blocks a client on XREADGROUP for stream `aga` (slot 609), sets slot 609 MIGRATING/IMPORTING, then MIGRATEs the key. The blocked client wakes and gets redirected.
Clean: MIGRATE returns OK and the server answers PING.
Buggy: the redirect path doesn't reset c->duration, so the server hits the duration assertion and aborts (connection closed, PING fails, "ASSERTION" printed).
