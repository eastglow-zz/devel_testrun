#include <iostream>
using namespace std;

class Circle {
  private:
    double radius;
  public:
    Circle(double r) : radius(r) {}
    double area() {return radius*radius*3.14159265;}
};

class Cylinder {
  private:
    Circle base;
    double height;
  public:
    Cylinder(double r, double h) : base (r), height(h) {}
    double volume() {return base.area() * height;}
};

int main() {
  Cylinder foo (10,20);

  cout << "foo's volume: " << foo.volume() << endl;
  return 0;
}
