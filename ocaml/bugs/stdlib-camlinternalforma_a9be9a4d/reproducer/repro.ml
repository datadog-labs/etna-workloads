let inspect (format : _ format6) =
  let (CamlinternalFormatBasics.Format (fmt, _)) = format in
  CamlinternalFormat.string_of_fmt fmt
let () = print_endline (inspect "@[foo@]"); print_endline (inspect "@[<%s>@]")
