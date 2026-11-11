let () =
  let o = Obj.new_block 100 1 in
  Obj.set_field o 0 (Obj.repr 1);
  let b = Marshal.to_bytes o [] in
  (* header 20 bytes, then small block code or block32 *)
  let p = 20 in
  if Bytes.get_uint8 b p = 0x08 then Bytes.set_uint8 b (p+4) 247
  else print_string "layout?";
  match (Marshal.from_bytes b 0 : Obj.t) with
  | _ -> print_endline "accepted"
  | exception Failure _ -> print_endline "rejected"
