module rec A: sig val x: int end = struct let x = B.x end
and B:sig val x: int end = struct let x = E.y end
and C:sig val x: int end = struct let x = B.x end
and D:sig val x: int end = struct let x = C.x end
and E:sig val x: int val y:int end = struct let x = D.x let y = 0 end
