Creates ExceptionGroup and BaseExceptionGroup+ValueError subclasses with a nested KeyboardInterrupt.
Clean: raises TypeError "Cannot nest BaseExceptions in '...'". Buggy: construction succeeds silently.
