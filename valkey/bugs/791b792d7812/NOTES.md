Loads 2000 Lua functions, runs `FUNCTION FLUSH SYNC`, and compares `used_memory_vm_functions` before and after.
Clean build: the Lua VM is re-created on flush, so memory drops ("memory reclaimed").
Buggy build: the engine reset is skipped, so memory is not reclaimed ("memory NOT reclaimed").
