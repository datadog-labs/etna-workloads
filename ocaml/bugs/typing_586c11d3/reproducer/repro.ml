class idfunc =
  object
    method id : 'ab. ([< `A | `B ] as 'ab) -> 'ab = fun x -> x
  end
let act : [ `A | `B ] -> [`A] =
 fun x -> (new idfunc)#id x
