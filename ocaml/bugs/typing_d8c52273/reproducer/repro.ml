let op =
  let module M = struct
      open struct let r = ref [] end
      let s = r
  end in
  M.s
let () = op := [1]
let _ = "a" :: !op
