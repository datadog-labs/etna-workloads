Runs two coroutines on one asyncio.Runner and counts policy.set_event_loop calls
before close. Clean: 1 (called once at loop creation). Buggy: 2 (called on every run()).
