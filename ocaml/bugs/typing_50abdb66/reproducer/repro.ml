type 'a t = [`A of 'a t t] as 'a;;
type 'a t = [`A of 'a t t];;
type 'a t = [`A of 'a t t] constraint 'a = 'a t;;
type 'a t = [`A of 'a t] constraint 'a = 'a t;;
type 'a t = [`A of 'a] as 'a;;
