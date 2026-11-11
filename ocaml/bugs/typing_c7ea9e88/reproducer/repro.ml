type s = [`A | `B] and sub = [`B]
type +'a t = T : [< `Conj of 'a & sub | `Other of string] -> 'a t
let f (T (`Other msg) : s t) = print_string msg
let _ = try f (T (`Conj `B) :> s t) with Match_failure _ -> print_string "mf"
