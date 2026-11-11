#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
trap 'rm -rf "$d"' EXIT
cat > "$d/s.c" <<'C'
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>
value static2young(value s, value f)
{
  CAMLparam2(s, f);
  static value r;
  value y;
  r = s;
  caml_register_generational_global_root(&r);
  y = caml_alloc_small(1, 0);
  Field(y, 0) = Val_int(0x42);
  caml_modify_generational_global_root(&r, y);
  value old = y;
  caml_callback(f, Val_unit);
  y = r;
  if (y == old) { caml_remove_generational_global_root(&r); CAMLreturn(Val_int(-1)); }
  caml_remove_generational_global_root(&r);
  CAMLreturn(Field(y, 0));
}
C
cat > "$d/m.ml" <<'M'
external static2young : int * int -> (unit -> unit) -> int = "static2young"
let () =
  let v = static2young (1, 1) (fun () -> Gc.minor (); Gc.full_major ()) in
  print_int (Obj.magic v lsr 0 land 0xffff); print_newline ()
M
"$1/bin/ocamlopt" -I "$d" -o "$d/m" "$d/s.c" "$d/m.ml" >/dev/null 2>&1 || { echo build failed; exit 1; }
out=$(timeout 20 "$d/m" 2>&1)
if [ "$out" = "66" ]; then echo ok; exit 0; fi
echo "bad: $out"; exit 1
