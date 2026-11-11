let () =
  List.iter (fun s ->
    let ast = Parse.implementation (Lexing.from_string s) in
    Format.printf "%a@." Pprintast.structure ast)
  ["let _ = (~$ x).contents";"let _ = r.f <- (fun x -> x)"; "let _ = r.f <- (a := b)"]
