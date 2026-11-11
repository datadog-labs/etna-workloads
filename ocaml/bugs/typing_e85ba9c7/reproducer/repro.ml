module Common =
 struct
   type msg = ..
   let handle_msg = ref (function _ -> failwith "Unable")
   let extend_handle f =
   let old = !handle_msg in
   handle_msg := f old
   let q : _ Queue.t = Queue.create ()
   let add msg = Queue.add msg q
 end

module M1 =
 struct
   type Common.msg += Reload of string
   let handle fallback = function
     Reload s -> print_endline s
   | x -> fallback x
   let () = Common.extend_handle handle
   let () = Common.add (Reload "c")
 end
