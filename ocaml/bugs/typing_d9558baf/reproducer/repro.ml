module M : sig type t = private [< `A | `B of string] end
= struct type t = [`A|`B of string] end
let () = print_string "ok\n"
