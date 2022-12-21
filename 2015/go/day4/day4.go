package day4

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strings"
)

func LowestPositive(input string) int {
	cnt := 0
	for {
		str := input + fmt.Sprintf("%d", cnt)
		hash := md5.Sum([]byte(str))
		hash_s := hex.EncodeToString(hash[:])
		if strings.Index(hash_s, "00000") == 0 {
			return cnt
		}
		cnt = cnt + 1
	}
}
