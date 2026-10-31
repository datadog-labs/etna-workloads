Enters the same asyncio.timeout() twice (nested). Clean: second __aenter__ raises
RuntimeError "Timeout has already been entered". Buggy: the state check is gone, so
no error is raised and the timeout is re-entered/rescheduled silently.
