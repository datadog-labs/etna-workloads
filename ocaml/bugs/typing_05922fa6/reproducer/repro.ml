module M :  sig
  type make_dec
  val add_dec: make_dec -> unit
end = struct
  module Fast: sig
    type 'd t
    val create: unit -> 'd t
    module type S = sig
      module Data: sig type t end
      val key: Data.t t
    end
    module Register (D:S): sig end
    val attach: 'd t -> 'd -> unit
  end = struct
    type 'd t = unit
    let create () = ()
    module type S = sig
      module Data: sig type t end
      val key: Data.t t
    end
    module Register (D:S) = struct end
    let attach _ _ = ()
  end
  type make_dec
  module Dem = struct
    module Data = struct
      type t = make_dec
    end
    let key = Fast.create ()
  end
  let _ = Dem.key
  module EDem = Fast.Register(Dem)
  let add_dec dec =
    Fast.attach Dem.key dec
end
