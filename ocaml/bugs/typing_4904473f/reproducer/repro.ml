module type S = sig module type T end
module type R = sig include S module type U = T include S end
