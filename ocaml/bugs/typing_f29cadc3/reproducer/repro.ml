module Pr7438 : sig end = struct
  module type S = sig type t = private [> `Foo] end
  module type T = sig
    type t = private [> `Foo | `Bar] include S with type t := t
  end
end;;
