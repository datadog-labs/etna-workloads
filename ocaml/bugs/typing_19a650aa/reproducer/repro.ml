type inkind = [ `Link | `Nonlink ]
type _ inline_t =
   | Text: string -> [< inkind > `Nonlink ] inline_t
   | Bold: 'a inline_t list -> 'a inline_t
   | Link: string -> [< inkind > `Link ] inline_t
   | Mref: string * [ `Nonlink ] inline_t list -> [< inkind > `Link ] inline_t
type ast_t =
   | Ast_Text of string
   | Ast_Bold of ast_t list
   | Ast_Link of string
   | Ast_Mref of string * ast_t list
type _ linkp =
 | Nonlink : [ `Nonlink ] linkp
 | Maylink : inkind linkp
type _ linkp2 = Kind : 'a linkp -> ([< inkind ] as 'a) linkp2
let inlineseq_from_astseq seq =
let rec process : type a. a linkp2 -> ast_t -> a inline_t =
  fun allow_link ast ->
    match (allow_link, ast) with
    | (Kind _, Ast_Text txt)    -> Text txt
    | (x, Ast_Bold xs)           -> Bold (List.map (process x) xs)
    | (Kind Maylink, Ast_Link lnk)    -> Link lnk
    | (Kind Nonlink, Ast_Link _)      -> assert false
    | (Kind Maylink, Ast_Mref (lnk, xs)) ->
        Mref (lnk, List.map (process (Kind Nonlink)) xs)
    | (Kind Nonlink, Ast_Mref _)      -> assert false
  in List.map (process (Kind Maylink)) seq
