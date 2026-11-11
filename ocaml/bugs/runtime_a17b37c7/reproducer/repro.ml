let () = print_endline (if Obj.tag (Obj.with_tag 42 (Obj.repr [| |])) = 42 then "ok" else "bad")
