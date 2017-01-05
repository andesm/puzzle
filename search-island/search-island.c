#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_XY 1000
#define MAX_SIZE MAX_XY * MAX_XY

int m[MAX_XY][MAX_XY];
int check[MAX_SIZE];

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

int searchIsland(int max_x, int max_y)
{
  int max_color = 0;
  int prev_change;
  int change_color = 0;
  
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
          for (int y2 = 0; y2 < y + 1; y2++) {
            for (int x2 = 0; x2 < max_x; x2++) {
              if (m[x2][y2] == m[x][y])
                m[x2][y2] = m[x][y - 1];
            }
          }
        }
        prev_change = 1;
      } else {
        if (prev_change)
          max_color += 1;
        prev_change = 0;
      }
    }
  }

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
    
