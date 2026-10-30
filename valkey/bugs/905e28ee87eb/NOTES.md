Saves a 100MB RDB, restarts the server with a slow load (key-load-delay, small loading-process-events-interval-bytes), then connects and disconnects 8 clients (`DEBUG LOG`) while it is still loading, and checks `connected_clients`.
Clean: closed clients are freed during loading ("clients freed"). Buggy: they are never freed during loading, so connected_clients stays high ("clients leaked").
