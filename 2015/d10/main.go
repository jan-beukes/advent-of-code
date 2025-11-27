package main

import (
	"fmt"
)

func next(number []byte) []byte {
	var nextNumber []byte
	i := 0
	for i < len(number) {
		c := number[i]
		count := 1
		i++
		for i < len(number) && number[i] == c {
			i++
			count++
		}
		nextNumber = append(nextNumber, byte(count + '0'), c)
	}
	return nextNumber
}

func partOne(input []byte) int {
	number := input
	for i := 0; i < 40; i++ {
		number = next(number)
	}
	return len(number)
}

func partTwo(input []byte) int {
	number := input
	for i := 0; i < 50; i++ {
		number = next(number)
	}
	return len(number)
}

func main() {
	input := []byte("1113122113")
	fmt.Println("Part one:", partOne(input))
	fmt.Println("Part two:", partTwo(input))
}
