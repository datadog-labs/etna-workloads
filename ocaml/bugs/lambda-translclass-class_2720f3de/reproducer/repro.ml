module M2 = struct
  let () = print_endline "Before class"
  class c =
    let open Unit in
    let () = print_endline "Class init" in
    object end
  let () = print_endline "After class"
  let _o1 = new c
end
