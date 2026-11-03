package main

func f(a, b float64, p []int, n int) int {
	v0 := p[0]
	v1 := p[1]
	v2 := p[2]
	v3 := p[3]
	v4 := p[4]
	v5 := p[5]
	v6 := p[6]
	v7 := p[7]
	v8 := p[8]
	v9 := p[9]
	v10 := p[10]
	v11 := p[11]
	v12 := p[12]
	for i := 0; i < n; i++ {
		if a == float64(v6) { v0 += v5 } else { v5 ^= v0 }
		if a == float64(v10) { v4 += v11 } else { v11 ^= v4 }
		if a != b { v3 = v6 }
		if a == float64(v12) { v12 += v12 } else { v12 ^= v12 }
		v12 += v4*v5
		if float64(v12) == b { v5 = v4 }
		v11 += v11*v7
		if float64(v11) == b { v7 = v11 }
	}
	return v0*1 + v1*2 + v2*3 + v3*4 + v4*5 + v5*6 + v6*7 + v7*8 + v8*9 + v9*10 + v10*11 + v11*12 + v12*13
}
func main(){ println(f(1,1,[]int{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16},3)) }
