module ParamsUnificationEnv = struct
  module type Sig =
    sig type 'a u = 'a list type +'a t constraint 'a = 'b u end
  type +'a t = 'b constraint 'a = 'b list
  module type Sig2 = Sig with type +'a t = 'a t
end
let () = print_string "ok\n"
