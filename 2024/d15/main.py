def parse_map():
    file = open("input.txt", "r")
    content = file.read().split("\n\n")
    file.close()
    map = content[0].split("\n")
    px, py = 0, 0
    for y, line in enumerate(map):
        map[y] = []
        for x, char in enumerate(line):
            if char == "@":
                map[y].append(".")
                map[y].append(".")
                py = y
                px = x
            elif char == "O":
                map[y].append("[")
                map[y].append("]")
            else:
                map[y].append(char)
                map[y].append(char)

    return map, content[1], px, py

def move_block(map, pxl, pxr, py, dx, dy) -> bool:
    if map[py + dy][pxl + dx] == "#" or map[py + dy][pxr + dx] == "#": return False
    if dx < 0:
        if map[py + dy][pxl + dx] == "]":
            if not move_block(map, pxl + dx - 1, pxl + dx, py + dy, dx, dy): return False
    elif dx > 0:
        if map[py + dy][pxr + dx] == "[":
            if not move_block(map, pxr + dx, pxr + dx + 1, py + dy, dx, dy): return False
    else:
        if map[py + dy][pxl] == "]":
            if not move_block(map, pxl + dx - 1, pxl + dx, py + dy, dx, dy): return False
        elif map[py + dy][pxr] == "[":
            if not move_block(map, pxr + dx, pxr + dx + 1, py + dy, dx, dy): return False
        elif map[py + dy][pxr] == "]" or map[py + dy][pxl] == "[":
            if not move_block(map, pxl, pxr, py + dy, dx, dy): return False

    map[py + dy][pxl + dx] = "["
    map[py + dy][pxr + dx] = "]"
    if dx < 0:
        map[py][pxr] = "."
    elif dx > 0:
        map[py][pxl] = "."
    else:
        map[py][pxr] = "."
        map[py][pxl] = "."
    return True

def move(map, px, py, dx, dy) -> bool:
    if map[py + dy][px + dx] == "#": return False
    if map[py + dy][px + dx] == "[":
        if not move_block(map, px + dx, px + dx + 1, py + dy, dx, dy): return False
    elif map[py + dy][px + dx] == "]":
        if not move_block(map, px + dx - 1, px + dx, py + dy, dx, dy): return False
    map[py + dy][px + dx] = "."
    map[py][px] = "."
    return True

def main():
    map, moves, px, py = parse_map()
    for m in moves:
        if m == "\n": continue
        dx, dy, = 0, 0
        if m == "<": dx = -1
        if m == ">": dx = 1
        if m == "^": dy = -1
        if m == "v": dy = 1
        if move(map, px, py, dx, dy):
            px += dx
            py += dy
    sum = 0
    for y, line in enumerate(map):
        print("".join(line))
        for x, char in enumerate(line):
            if (char == "[" and line[x + 1] == "]"):
                sum += y * 100 + x
    print(sum)

main()

