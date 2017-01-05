#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unordered_map>
#include <map>

#define MAX_XY 1000
#define MAX_SIZE MAX_XY * MAX_XY

using namespace std;  

int m[MAX_XY][MAX_XY];
unordered_map<int, unordered_map<int, int>> change_fromto_hash;
int check[MAX_SIZE];

void printColor(void)
{
      for (auto c1 = change_fromto_hash.begin(); c1 != change_fromto_hash.end(); c1++) {
        printf("%d : ", c1->first);
        for (auto c2 = c1->second.begin(); c2 != c1->second.end(); c2++) {
          printf("(%d, %d) ", c2->first, c2->second);
        }
        printf("\n");
      }
      printf("\n");
}

void printM(int max_x, int max_y)
{
  printf("%d %d\n", max_x, max_y);
  for (int y = 0; y < max_y; y ++) {
    for (int x = 0; x < max_x; x ++) {
      printf("%2d ", m[x][y]);
    }
    printf("\n");
  }
  printf("\n");
}

map<int, int> getChangeColor(int color, map<int, int> result_color_hash)
{
  result_color_hash[color] = -1;
  auto c1 = change_fromto_hash.find(color);
  if (c1 != change_fromto_hash.end()) {
    if (0 < change_fromto_hash[color][color])
      result_color_hash[change_fromto_hash[color][color]] = -1;
    else {
      for (auto c2 = c1->second.begin(); c2 != c1->second.end(); c2++) {
        int c = c2->first;
        if (result_color_hash.find(c) == result_color_hash.end()) {
            map<int, int> r = getChangeColor(c, result_color_hash);
            for (auto rc = r.begin(); rc != r.end(); rc++)
              result_color_hash[rc->first] = -1;
        }
      }
    }
  }
  
  return result_color_hash;
}

int searchIsland(int max_x, int max_y)
{
  int max_color = 0;
  int change_color = 0;
  int prev_change;

  for (int y = 0; y < max_y; y++) {
    prev_change = 0;
    max_color += 1;
    for (int x = 0; x < max_x; x++) {
      if (m[x][y] != 0) {
        if (x != 0 && m[x - 1][y] != 0)
          m[x][y] = m[x - 1][y];
        else
          m[x][y] = max_color;
        if (y != 0 && m[x][y - 1] != 0) {
          change_fromto_hash[m[x][y]][m[x][y]] = -1;
          change_fromto_hash[m[x][y]][m[x][y - 1]] = -1;
          change_fromto_hash[m[x][y - 1]][m[x][y]] = -1;
        }
        prev_change = 1;
      } else {
        if (prev_change)
          max_color += 1;
        prev_change = 0;
      }
    }
  }

  //printM(max_x, max_y);         
  //printColor();
  
  for (int x = 0; x < max_x; x++) {
    for (int y = 0; y < max_y; y++) {
      map<int, int> result_color_hash;
      result_color_hash = getChangeColor(m[x][y], result_color_hash);
      if (result_color_hash.begin() != result_color_hash.end()) {
        int im = result_color_hash.begin()->first;
        if (im != 0) {
          change_fromto_hash[m[x][y]][m[x][y]] = im;
          m[x][y] = im;
        }
      }
    }
  }

  //printM(max_x, max_y);         
  //printColor();

  for (int y = 0; y < max_y; y++) {
    for (int x = 0; x < max_x; x++) {
      check[m[x][y]] = 1;
    }
  }

  int count = 0;
  for (int i = 1; i < MAX_SIZE; i++) {
    if (check[i] == 1)
      count++;
  }

  return count;
}

int main(void)
{
  int max_x, max_y;
  char str[3000], *token1, *token2;

  fgets(str, sizeof(str), stdin);
  str[strlen(str) - 1] = '\0';
  max_x = atoi(strtok(str, " "));
  max_y = atoi(strtok(NULL, " "));
  for (int y = 0; y < max_y; y ++) {
    fgets(str, sizeof(str), stdin);
    str[strlen(str) - 1] = '\0';
    for (int x = 0; x < max_x; x ++) {
      if (x == 0)
        m[x][y] = atoi(strtok(str, " "));
      else
        m[x][y] = atoi(strtok(NULL, " "));
    }
  }
    
  int count = searchIsland(max_x, max_y);         
  printf("%d\n", count);
}
    
