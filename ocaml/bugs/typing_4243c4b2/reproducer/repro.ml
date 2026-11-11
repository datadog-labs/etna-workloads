module Shape_arg = struct
  module M1 (Arg1 : sig end) = struct
    module type S1 = sig type t end
  end
  module type S2 = sig
    module Make (Arg2 : sig end) : M1(Arg2).S1
  end
  module M2 : S2 = struct
    module Make (Arg3 : sig end) = struct type t = unit end
  end
  module M3 (Arg4 : sig end) = struct
    module type S3 = sig type t = M2.Make(Arg4).t end
  end
  module M4 (Arg5 : sig end) : M3(Arg5).S3 = struct
    module M5 = M2.Make (Arg5)
    type t = M5.t
  end
end
let () = print_string "ok\n"
