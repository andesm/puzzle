import random

max_x = 100
max_y = 100

print("%d %d" % (max_x , max_y))
for y in range(max_y):
    for x in range(max_x):
        if x == max_x - 1:
            print("%d" % 1)
            #print("%d" % random.randint(0,1))
        else:
            print("%d " % 1, end="")
            #print("%d " % random.randint(0,1), end="")
