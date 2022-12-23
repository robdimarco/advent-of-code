package day4

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strings"
)

func LowestPositive(input string, zeros int) int {
	cnt := 0
	target := strings.Repeat("0", zeros)

	for {
		str := input + fmt.Sprintf("%d", cnt)
		hash := md5.Sum([]byte(str))
		hash_s := hex.EncodeToString(hash[:])
		if strings.Index(hash_s, target) == 0 {
			return cnt
		}
		cnt = cnt + 1
	}
}
