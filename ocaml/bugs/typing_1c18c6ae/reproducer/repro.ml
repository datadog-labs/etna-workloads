type 'a t
let dog : 'this =
  let module Dog = struct
    external make
      : bark:('self -> unit)
      -> < bark : ('self -> unit) > t = "%identity"
  end
  in
  Dog.make ~bark:(fun (o : 'this) -> ())
