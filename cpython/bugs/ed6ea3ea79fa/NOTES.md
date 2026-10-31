A Protocol class with a member whose descriptor `__get__` raises RuntimeError.
Clean: non-runtime protocol is created fine (prints ['evil']); runtime_checkable raises
TypeError "Failed to determine whether protocol member 'evil' is a method member" caused by RuntimeError.
Buggy: _ProtocolMeta.__init__ does getattr on every member, so class creation raises RuntimeError.
