
def printM(m):
    for y in range(max_y):
        for x in range(max_x):
            print("%3d " % m[y][x], end="")
        print("")
    print("")

def printColor(change_fromto_hash):
    for i in change_fromto_hash:
        print(i, change_fromto_hash[i])
    print("");

def getChangeColor(color, result_color_hash, change_fromto_hash):
    result_color_hash[color] = -1
    if color in change_fromto_hash:
        if color in change_fromto_hash[color] and 0 < change_fromto_hash[color][color]:
             result_color_hash[change_fromto_hash[color][color]] = -1
        else:
            for c in change_fromto_hash[color]:
                if not c in result_color_hash:
                    for rc in getChangeColor(c, result_color_hash, change_fromto_hash):
                        result_color_hash[rc] = -1

    return result_color_hash

def setChangeFromToHash(m, change_fromto_hash, x, y, a):
    if y != 0 and m[y - 1][x] != 0:
        if m[y][x] not in change_fromto_hash:
            change_fromto_hash[m[y][x]] = {}
        if m[y - 1][x] not in change_fromto_hash:
            change_fromto_hash[m[y - 1][x]] = {}
        change_fromto_hash[m[y][x]][m[y][x]] = a
        change_fromto_hash[m[y][x]][m[y - 1][x]] = a
        change_fromto_hash[m[y - 1][x]][m[y][x]] = a
                        
def searchIsland(m, max_x, max_y):
    max_color = 0
    change_fromto_hash = {};
    
    for y in range(max_y):
        prev_change = False
        max_color += 1
        for x in range(max_x):
            if m[y][x] != 0:
                if x != 0 and m[y][x - 1] != 0:
                    m[y][x] = m[y][x - 1]
                else:
                    m[y][x] = max_color
                setChangeFromToHash(m, change_fromto_hash, x, y, -1)
                prev_change = True
            else:
                if prev_change:
                    max_color += 1
                prev_change = False

    #printM(m)
    #printColor(change_fromto_hash)
                
    for y in range(max_y):
        for x in range(max_x):
            result_color_hash = {}
            mc = min(getChangeColor(m[y][x], result_color_hash, change_fromto_hash))
            if m[y][x] in change_fromto_hash:
                change_fromto_hash[m[y][x]][m[y][x]] = mc
            m[y][x] = mc

    #printM(m)
    #printColor(change_fromto_hash)
            
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

        
