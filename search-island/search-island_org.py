
def printM(m):
    for y in range(max_y):
        for x in range(max_x):
            print("%2d " % m[y][x], end="")
        print("")
    print("")
    
def searchIsland(m, max_x, max_y):
    max_color = 1
    for y in range(max_y):
        prev_change = False
        max_color += 1
        for x in range(max_x):
            if m[y][x] != 0:
                if x != 0 and m[y][x - 1] != 0:
                    m[y][x] = m[y][x - 1]
                else:
                    m[y][x] = max_color
                if y != 0 and m[y - 1][x] != 0:
                    for y2 in range(y + 1):
                        for x2 in range(max_x):
                            if m[y2][x2] == m[y][x]:
                                m[y2][x2] = m[y - 1][x]
                prev_change = True
            else:
                if prev_change:
                    max_color += 1
                prev_change = False

    c = {}
    for y in range(max_y):
        for x in range(max_x):
            if m[y][x] != 0:
                c[m[y][x]] = 1
                
    ic = 0
    for i in c:
        ic += 1
      
    return ic
                
if __name__ == '__main__':
    size = input().split()
    max_x = int(size[0])
    max_y = int(size[1])
    m = []
    for y in range(max_y):
        m.append(input().split())
    for y in range(max_y):
        for x in range(max_x):
            m[y][x] = int(m[y][x])

    print(searchIsland(m, max_x, max_y))

        
