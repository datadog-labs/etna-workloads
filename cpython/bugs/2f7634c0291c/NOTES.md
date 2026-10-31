Pickles and unpickles an ArgumentParser, then parses args with it.
Clean: prints Namespace(help=..., foo=123). Buggy: the registry's `type` None entry is a
local function (`identity` in __init__), so pickling fails with a
PicklingError about a local object.
