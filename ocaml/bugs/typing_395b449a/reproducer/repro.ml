type t = { x : int; self : t }
let rec x = 1
and u = Some { t with x = 2 }
and t = { x; self = t }
let () = match u with None -> () | Some {self;_} -> assert (self.x = t.x)
