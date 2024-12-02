
def part1():
    bag = {
        "red" : 12,
        "green" : 13,
        "blue" : 14
        }

    id_sum = 0
    with open("d2input","r") as file:
        lines = file.readlines()
        id = 0
        for game in lines:
            id += 1
            invalid_flag = False
            sets = game.split(":")[1].split(";")
            for set in sets:
                cubes = set.split(",")
                for cube in cubes:
                    token = cube.strip().split(" ")
                    print(token)
                    if int(token[0]) > bag[token[1]]:
                        invalid_flag = True
                        break
                if invalid_flag:
                    break
            else:
                id_sum += id    

    print(id_sum)
    
def part2():
   
    power_sum = 0
    with open("d2input","r") as file:
        lines = file.readlines()
        for game in lines:
            max_cubes = {
            "red":0,
            "green":0,
            "blue":0
            }   
            sets = game.split(":")[1].split(";")
            for set in sets:
                cubes = set.split(",")
                for cube in cubes:
                    token = cube.strip().split(" ")
                    max_cubes[token[1]] = max(max_cubes[token[1]], int(token[0]))
            values = list(max_cubes.values())
            power_sum += values[0] * values[1] * values[2]
            print(max_cubes, values[0] * values[1] * values[2])
    print (power_sum)
    
part2()
