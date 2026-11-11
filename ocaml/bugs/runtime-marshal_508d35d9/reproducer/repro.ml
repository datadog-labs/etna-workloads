(* Reproducer for intern.c missing bounds check on obj_counter *)

type cell = Nil | Cons of int * cell

let () =
  let rec build n acc = if n = 0 then acc else build (n-1) (Cons (n, acc)) in
  let v = build 5000 Nil in
  let s = Marshal.to_string v [] in
  let b = Bytes.of_string s in
  (* Small-header format: magic(4) data_len(4) num_objects(4) ... *)
  (* Force num_objects down to 1, far below the real number of blocks
     that will be recorded while unmarshaling. *)
  Bytes.set_uint8 b 8 0;
  Bytes.set_uint8 b 9 0;
  Bytes.set_uint8 b 10 0;
  Bytes.set_uint8 b 11 1;
  (try
     let (_ : Obj.t) = Marshal.from_bytes b 0 in
     print_string "accepted"
   with
   | Failure _ -> print_string "failure"
   | Invalid_argument _ -> print_string "invalid_argument"
   | Out_of_memory -> print_string "out_of_memory");
  print_newline ()
