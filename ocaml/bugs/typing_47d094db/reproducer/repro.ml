module Test = struct type t = private A end
module Test2 : module type of Test with type t = Test.t = Test
let f Test2.A = ()
