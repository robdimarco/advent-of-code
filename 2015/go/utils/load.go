package utils

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

// InputFileAsString returns the entire contents of the input file as a string.
func InputFileAsString(inputFilePath string) string {
	buf, err := os.ReadFile(inputFilePath)
	if err != nil {
		log.Fatal(err)
	}

	return string(buf)
}

func InputFileAsLines(day string) []string {
	filePath := "../../ruby/" + day + ".txt"
	readFile, err := os.Open(filePath)

	if err != nil {
		fmt.Println(err)
	}
	fileScanner := bufio.NewScanner(readFile)
	fileScanner.Split(bufio.ScanLines)
	var fileLines []string

	for fileScanner.Scan() {
		fileLines = append(fileLines, fileScanner.Text())
	}

	readFile.Close()

	return fileLines
}
