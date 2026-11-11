class c = object method m ?(x=1) () = x method n = 1 end;;
class d = object (self) inherit c method n' = self#m () end;;
