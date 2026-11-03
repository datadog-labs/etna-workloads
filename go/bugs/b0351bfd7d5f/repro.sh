export GOCACHE="$PWD/gocache"
cat > x.go <<'EOG'
package x

func Load32(b []byte) uint32 {
	return uint32(b[3]) | uint32(b[2])<<8 | uint32(b[1])<<16 | uint32(b[0])<<24
}

func Load64(b []byte) uint64 {
	return uint64(b[7]) | uint64(b[6])<<8 | uint64(b[5])<<16 | uint64(b[4])<<24 |
		uint64(b[3])<<32 | uint64(b[2])<<40 | uint64(b[1])<<48 | uint64(b[0])<<56
}

func Store32(b []byte, v uint32) {
	b[0], b[1], b[2], b[3] = byte(v>>24), byte(v>>16), byte(v>>8), byte(v)
}
EOG
GOOS=linux GOARCH=amd64 GOAMD64=v1 "$GO" build -trimpath -gcflags=-S ./x.go 2>&1 | grep -oE '\b(MOVBE[LQ]|BSWAP[LQ])\b' | sort | uniq -c
