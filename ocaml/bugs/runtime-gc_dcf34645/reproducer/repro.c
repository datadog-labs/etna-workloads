#define CAML_INTERNALS
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/major_gc.h>
value stub(value r){
  CAMLparam1(r);
  CAMLlocal1(x);
  caml_minor_collection(); caml_finish_major_cycle(0); caml_finish_major_cycle(0);
  x = caml_alloc(Max_young_wosize+10, 0);
  x = caml_alloc_string(Max_young_wosize*8+100);
  x = caml_alloc_float_array(Max_young_wosize+10);
  CAMLreturn(Val_long(Long_val(Field(r,0))));
}
