let x :> <m:int> = object method m = 0 method n=1 end
let () = print_int (x#m)
