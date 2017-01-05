#!/bin/bash

while [ 1 ]
do
    python make_serch-island.py > search-island_test.txt
    #a=$(python search-island_org.py < search-island_test.txt)
    a=$(./a.out < search-island_test.txt)
    b=$(python search-island3.py < search-island_test.txt)

    echo $a
    echo $b
    if [ $a != $b ]
    then
        exit 1
    fi
done

