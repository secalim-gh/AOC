#include <stdio.h>
#include <stdlib.h>

char *a[] = {
  "L68",
  "L30",
  "R48",
  "L5",
  "R60",
  "L55",
  "L1",
  "L99",
  "R14",
  "L82"
};

#define SIZE(a) (sizeof((a)))/(sizeof((a[0])))

int main(void) {
  int n = 50;
  for (int i = 0; i < SIZE(a); i++) {
    int m = a[i][0] == 'L' ? -atoi(a[i]+1) : atoi(a[i]+1);
    n += m;
    n = 100 + n;
    n %= 100;
    printf("%s %d %d\n", a[i], m, n);
  }
  return 0;
}
