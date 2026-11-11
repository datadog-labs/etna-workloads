module type Dep = sig type t val x : t end
module String = struct type t = string let x = "Forty Two" end
module Int = struct type t = int let x = 42 end
module type S = sig
  val x : 'a option
  module M : functor (X : Dep) -> sig
    val x : X.t option
    module M : functor (Y : Dep) -> sig
      val x : X.t option
    end
  end
end
module type S' = sig
  val x : 'a option
  module M : functor (_ : Dep) -> S
end
module Bad (A : S') : S = A
