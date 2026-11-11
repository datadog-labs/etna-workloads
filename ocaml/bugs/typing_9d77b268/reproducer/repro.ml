let id x = x
let d = id (let r = ref [] in (!r, fun x -> r := x))
let () = (snd d) [1]; (snd d) ["a"]
