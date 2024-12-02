with open("d3input", "r") as file:
    
    characters = "=/%*+@#-$&"
    sum = 0
    symbols = []
    numbers = {}
    on_num = False
    current_num = (0,0)
    grid = file.readlines()
    rows, cols = len(grid), len(grid[0]) 
    
    for y, row in enumerate(grid):
        for x, char in enumerate(row):
            if char in characters:
                symbols.append((y,x))
            if char.isdigit() and not on_num:
                on_num = True
                current_num = (y, x)
                numbers[current_num] = char
            elif char.isdigit() and on_num:
                numbers[current_num] += char
            else:
                on_num = False
    locations = numbers.keys()
    for y,x in symbols:    
        test = [(y-1,x-3), (y-1,x-2), (y-1,x-1),(y-1,x), (y-1,x+1), 
                (y,x-3), (y,x-2), (y,x-1), (y,x+1),
                (y+1,x-3), (y+1,x-2), (y+1,x-1), (y+1,x), (y+1,x+1)]
        for c in test:
            if c in locations:
                # check non 3 digit
                if c[1] < x and x - c[1] > len(numbers[c]):
                    continue
                sum+=int(numbers[c])
                
    print(sum)            
                  
    