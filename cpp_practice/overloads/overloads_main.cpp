#include <iostream>
using namespace std;

int operate (int a, int b)
{
  return (a*b);
}

double operate (double a, double b)
{
  return (a/b);
}

double operate (double a, double b, double c)
{
  return (c > 0 ? a : b);
}

int main()
{
  int x=5, y=2;
  double n=5.0, m=2.0;
  double o=-2.0, p=1.0, q=-1.0;
  cout << operate (x,y) << endl;
  cout << operate (n,m) << endl;
  cout << operate (p,q,o) << endl;
  return 0;
}
