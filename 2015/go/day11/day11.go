package day11

import "strings"

func ValidLetters(password string) bool {
	return !strings.Contains(password, "i") && !strings.Contains(password, "o") && !strings.Contains(password, "l")
}

func HasStraight(password string) bool {
	bytes := []byte(password)
	i := 0
	for i < len(password)-2 {
		if (bytes[i]+1 == bytes[i+1]) && (bytes[i+1]+1 == bytes[i+2]) {
			return true
		}
		i++
	}
	return false
}

func HasPairs(password string) bool {
	i := 0
	Cnt := 0
	Bytes := []byte(password)
	for i < len(password)-1 {
		if Bytes[i] == Bytes[i+1] {
			Cnt++
			i++
		}
		i++
	}
	return Cnt > 1
}

func ValidPassword(Password string) bool {
	return ValidLetters(Password) && HasStraight(Password) && HasPairs(Password)
}

func IncrementPassword(Password string) string {
	for {
		bytes := []byte(Password)
		i := len(bytes) - 1
		for i >= 0 {
			bytes[i] += 1
			if bytes[i] <= 122 {
				break
			}
			bytes[i] = 97
			i -= 1
		}

		Password = string(bytes)
		if ValidPassword(Password) {
			return Password
		}
	}
}
