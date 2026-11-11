module F(S : sig type 'a t end) = struct
  type _ ab = A : int S.t ab | B : float S.t ab
  let f : int S.t ab -> float S.t ab -> string =
    fun l r -> match l, r with
    | A, B -> "f A B"
end
