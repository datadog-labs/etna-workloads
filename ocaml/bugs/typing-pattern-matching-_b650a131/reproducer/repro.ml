let f = function Some Not_found -> 1 | None -> 2
let g = function Some Not_found when true -> 1 | _ -> 2
