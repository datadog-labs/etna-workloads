class ['a] c = object (_ : 'a)
  constraint 'a = < .. >
end
let o =
  object
    inherit [ < m : int > ] c
    method m = 1
  end
