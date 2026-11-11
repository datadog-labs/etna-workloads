module Unused_nonrec : sig
end = struct
  type nonrec used = int
  type nonrec unused = used
end
