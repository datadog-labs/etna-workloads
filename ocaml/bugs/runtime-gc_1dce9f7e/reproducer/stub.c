#define CAML_INTERNALS
#include <stdio.h>
#include <caml/mlvalues.h>
#include <caml/lf_skiplist.h>
value run(value u){
  struct lf_skiplist sk; int bad=0, N=128;
  caml_lf_skiplist_init(&sk);
  for(int r=0;r<6;r++){
    for(int k=1;k<=N;k++) caml_lf_skiplist_insert(&sk,k,0);
    for(int k=1;k<=N;k++) caml_lf_skiplist_remove(&sk,k);
    int n=0; struct lf_skipcell *c=atomic_load(&sk.garbage_head);
    while(c && n<10*N){ n++; c=atomic_load(&c->garbage_next);}
    if(n!=N+1) bad=1;
    caml_lf_skiplist_free_garbage(&sk);
  }
  return Val_int(bad);
}
