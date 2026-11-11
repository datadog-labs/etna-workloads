type _ t =
  | Value_int of int
  | Value_snd : ('a,'b option) result -> 'b t
let f (x : _ t) =
  match x with
  | (Value_int _ | Value_snd (Ok _ | Error None)) as y -> y
  | Value_snd (Error (Some _)) -> Value_snd (Error None)
