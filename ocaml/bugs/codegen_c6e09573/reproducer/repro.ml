external unsafe_get : 'a array -> int -> 'a = "%array_unsafe_get"
let uget = unsafe_get
let () =
  let int32 = 123456l in
  let arr = [| int32 |] in
  let n = uget arr 0 in
  assert (n = int32); print_string "ok\n"
