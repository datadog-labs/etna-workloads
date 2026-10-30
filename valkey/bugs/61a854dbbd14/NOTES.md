Runs CLIENT TRACKINGINFO on a fresh connection (tracking never enabled).
Clean: returns flags=off, redirect=-1, empty prefixes, then PING works.
Buggy: the prefixes check lacks the `c->flag.tracking` guard, so the NULL pubsub_data is dereferenced and the server crashes (CLI cannot connect afterwards).
