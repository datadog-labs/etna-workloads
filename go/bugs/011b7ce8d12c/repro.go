package main

func _[C chan<- int | chan int](c C)   { c <- 0 }
func _[C chan int | chan<- int](c C)   { c <- 0 }
func _[C <-chan int | chan<- int](c C) { c <- 0 }

func _[C <-chan int | chan int](c C)   { <-c }
func _[C chan int | <-chan int](c C)   { <-c }
func _[C chan<- int | <-chan int](c C) { <-c }

func main() {}
