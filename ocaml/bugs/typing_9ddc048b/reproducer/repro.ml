module F(X : sig type 'a t end) = struct
  type (_, _) gadt = T : ('a X.t, 'a) gadt
  let eq (type tt m1 m2)
        (T : (tt, m1) gadt) (T : (tt, m2) gadt) : (m1, m2) Type.eq =
     Equal
end
