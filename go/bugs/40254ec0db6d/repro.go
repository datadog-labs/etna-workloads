package main

import (
	"fmt"
	"reflect"
	"unsafe"
)

func main() {
	t := reflect.TypeOf(unsafe.Pointer(nil))
	fmt.Printf("PkgPath=%q\n", t.PkgPath())
}
