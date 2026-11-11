let x = object  method g = "abc" end
let s =  (object method f = x#g end)#f
let () = prerr_endline s
