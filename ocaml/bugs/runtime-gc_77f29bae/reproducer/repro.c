#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <stdlib.h>
struct box { value v; };
#define Box(v) (*((struct box **) Data_custom_val(v)))
static void fin(value b){
  struct box *p = Box(b);
  caml_remove_generational_global_root(&p->v);
  free(p);
}
static struct custom_operations ops = {"box", fin, custom_compare_default,
  custom_hash_default, custom_serialize_default, custom_deserialize_default,
  custom_compare_ext_default, custom_fixed_length_default};
value box_make(value v){
  CAMLparam1(v);
  CAMLlocal1(r);
  struct box *p = malloc(sizeof *p);
  p->v = v;
  caml_register_generational_global_root(&p->v);
  r = caml_alloc_custom(&ops, sizeof(struct box *), 0, 1);
  Box(r) = p;
  CAMLreturn(r);
}
value box_deref(value b){ return Box(b)->v; }
