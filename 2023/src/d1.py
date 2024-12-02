SDIGITS = ("one","two","three","four","five","six","seven","eight",'nine')

with open("d1input","r") as file:
    lines = file.readlines()
    sum = 0
    count = 1
    for line in lines:
        first, last = None, None
        first_index, last_index = len(line), 0
        for char in range(len(line)) :
            if line[char].isdigit() and not first:
                first = line[char]
                first_index = char
            if line[char].isdigit():
                last = line[char]
                last_index = char
        for i in range(len(SDIGITS)):
            if -1 < line.find(SDIGITS[i]) < first_index: 
                first = str(i + 1)
                first_index = line.find(SDIGITS[i])
            if line.rfind(SDIGITS[i])>= last_index:
                last = str(i + 1)
                last_index = line.rfind(SDIGITS[i])
     
   
        print(f"{count} {first} {last} = {int(first + last)} | index: {first_index} {last_index}")
        sum += int(first + last)
        count+=1
    print(sum)