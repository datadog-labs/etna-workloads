let () =
  let g = Gc.get () in
  Gc.set { g with Gc.custom_major_ratio = 40; custom_minor_ratio = 99; custom_minor_max_size = 4096 };
  let g2 = Gc.get () in
  Printf.printf "%d %d %d\n" g2.custom_major_ratio g2.custom_minor_ratio g2.custom_minor_max_size
