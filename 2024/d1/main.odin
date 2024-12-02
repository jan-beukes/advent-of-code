package d1

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	file, err := os.open("input.txt")

	content, _ := os.read_entire_file(file)
	s := string(content)
	lines := strings.split_lines(s)

	left := make([]int, len(lines))
	right := make([]int, len(lines))

	for line, i in lines {
		if strings.compare(line, "") == 0 do continue

		nums := strings.split(line, "   ")
		left[i], _ = strconv.parse_int(nums[0])
		right[i], _ = strconv.parse_int(nums[1])
	}

	slice.sort(left)
	slice.sort(right)

	similarity: int
	for i in 0 ..< len(left) {
		num := left[i]
		similarity += num * slice.count(right, num)
	}

	fmt.println(similarity)

}
