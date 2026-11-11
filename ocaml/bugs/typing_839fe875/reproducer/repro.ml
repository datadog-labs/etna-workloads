type 'a foo = { x: 'a; y: int }
let f (r: string foo) = ({ r with y = 3 } : int foo)
