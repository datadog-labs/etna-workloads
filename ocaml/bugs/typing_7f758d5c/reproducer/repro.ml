type untyped;;
type -'a typed = private untyped;;
type -'typing wrapped = private sexp
and +'a t = 'a typed wrapped
and sexp = private untyped wrapped;;
