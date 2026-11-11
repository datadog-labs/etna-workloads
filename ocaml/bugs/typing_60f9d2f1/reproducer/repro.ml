module M = struct
  type _ rr = Soa : int rr
  type b = B : 'a rr * 'a -> b
end
let test =
  let M.(B (k, v)) = M.(B (Soa, 0)) in
  match k, v with
  | M.Soa, soa -> (soa : int)
let () = print_int test
