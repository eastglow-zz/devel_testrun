#include <stdio.h>

int main()
{
  ///////////////
  int dim = 0;
  int result=1;
  ///////////////
  switch (dim)
  {
    case 3:
      result += 1;
      result += 1;
      break;
    case 2:
      result += 1;
      break;
    case 1:
      break;
    default:
      printf("out of range\n");
      break;
  }
  printf("dim = %d, result = %d\n",dim, result);

  return 0;
}
