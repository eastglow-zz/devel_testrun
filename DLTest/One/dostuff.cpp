#include <iostream>
#include "../DLTestAPI.h"

double val = 1.0;

void
DoMoreExternStuff(void)
{
    std::cout << "In One::DoMoreExternStuff" << std::endl;
}

void
DoMoreNonExternStuff(void)
{
    std::cout << "In One::DoNonMoreExternStuff" << std::endl;
}

void
DoStuff(void)
{
    std::cout << "In One::DoStuff, val=" << val << std::endl;
    DoMoreExternStuff();
    DoMoreNonExternStuff();
}


