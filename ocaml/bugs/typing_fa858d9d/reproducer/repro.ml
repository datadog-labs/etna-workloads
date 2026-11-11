module rec M: sig
  type x
  type 'a t = A constraint 'a = <x: 'a. 'a -> x >
end = struct
  type x
  type 'a t = A constraint 'a = <x:'a. 'a -> 'a >
end
