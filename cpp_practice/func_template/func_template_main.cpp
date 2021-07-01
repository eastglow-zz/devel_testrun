#include <iostream>
using namespace std;

template <class myt>
myt sum (myt a, myt b)
{
  return a+b;
}

int main()
{
  double x=1.55555, y=2.;
  int i=3, j=4;

  cout << (double)sum<double>(x,y) << endl;
  cout << sum<int>(i,j) << endl;

  return 0;
}
