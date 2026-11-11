class type gui = object method sub: 'b. 'b -> 'b end
class virtual local_sub = object method virtual sub: 'b. 'b -> 'b option end
class virtual ['a] compound_gui =
  object (_: #gui)
    constraint 'a = #local_sub
  end
