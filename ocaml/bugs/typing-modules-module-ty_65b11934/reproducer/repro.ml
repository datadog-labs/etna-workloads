module A1 = struct end
module A2 = struct end
module L1 = struct module X = A1 end
module L2 = struct module X = A2 end
module F(L : module type of L1 [@remove_aliases]) = struct end
module F1 = F(L1)
module F2 = F(L2)
