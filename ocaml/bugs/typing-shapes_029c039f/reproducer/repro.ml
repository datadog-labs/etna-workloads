module Mdirect = Stdlib__Unit
module F (X : sig type t end) = X
module App_direct_indir = F (Mdirect)
