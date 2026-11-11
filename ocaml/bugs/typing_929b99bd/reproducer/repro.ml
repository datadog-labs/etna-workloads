type fpclass = A
module B: sig val f: fpclass -> fpclass end =
  struct let f A = FP_normal end
