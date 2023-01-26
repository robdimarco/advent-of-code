package day7

import (
	"strconv"
	"strings"
)

func Part1(lines []string) map[string]uint16 {
	rv := make(map[string]uint16)
	linesToProcess := make([]string, len(lines))
	copy(linesToProcess, lines)
	for {
		if len(linesToProcess) == 0 {
			break
		}

		line := linesToProcess[0]
		linesToProcess = linesToProcess[1:]

		if !ApplyCommand(rv, line) {
			linesToProcess = append(linesToProcess, line)
		}
	}

	return rv
}
func Part2(lines []string) map[string]uint16 {
	rv := make(map[string]uint16)
	linesToProcess := make([]string, len(lines))
	copy(linesToProcess, lines)

	rv["b"] = Part1(lines)["a"]
	for {
		if len(linesToProcess) == 0 {
			break
		}

		line := linesToProcess[0]
		linesToProcess = linesToProcess[1:]

		if !ApplyCommand(rv, line) {
			linesToProcess = append(linesToProcess, line)
		}
	}

	return rv
}

func ApplyCommand(hash map[string]uint16, line string) bool {
	split := strings.Split(line, " -> ")
	action := split[0]
	target := split[1]
	if _, ok := hash[target]; ok {
		return true
	}

	if strings.Contains(action, "AND") {
		split := strings.Split(action, " AND ")
		val1, ok := GetValue(hash, split[0])
		val2, ok2 := GetValue(hash, split[1])
		if !ok || !ok2 {
			return false
		}
		hash[target] = val1 & val2
	} else if strings.Contains(action, "OR") {
		split := strings.Split(action, " OR ")
		val1, ok := GetValue(hash, split[0])
		val2, ok2 := GetValue(hash, split[1])
		if !ok || !ok2 {
			return false
		}
		hash[target] = val1 | val2
	} else if strings.Contains(action, "LSHIFT") {
		split := strings.Split(action, " LSHIFT ")
		val1, ok := GetValue(hash, split[0])
		val2, ok2 := GetValue(hash, split[1])
		if !ok || !ok2 {
			return false
		}
		hash[target] = val1 << val2
	} else if strings.Contains(action, "RSHIFT") {
		split := strings.Split(action, " RSHIFT ")
		val1, ok := GetValue(hash, split[0])
		val2, ok2 := GetValue(hash, split[1])
		if !ok || !ok2 {
			return false
		}
		hash[target] = val1 >> val2
	} else if strings.Contains(action, "NOT") {
		split := strings.Split(action, "NOT ")
		val, ok := GetValue(hash, split[1])
		if !ok {
			return false
		}
		hash[target] = ^val
	} else {
		val, ok := GetValue(hash, action)
		if !ok {
			return false
		}
		hash[target] = val
	}
	return true
}

func GetValue(hash map[string]uint16, key string) (uint16, bool) {
	if parse, err := strconv.ParseUint(key, 10, 16); err == nil {
		return uint16(parse), true
	}
	val, ok := hash[key]
	return val, ok
}
