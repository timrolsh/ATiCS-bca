with open('./script.txt', 'r') as file:
    lines = file.readlines()

with open('./appendix-1-in.txt', 'w') as in_file, open('./appendix-1-out.txt', 'w') as out_file:
    for index, line in enumerate(lines):
        if index % 2 == 0:
            in_file.write(line)
        else:
            out_file.write(line)