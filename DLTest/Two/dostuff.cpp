#include <iostream>
#include "../DLTestAPI.h"

double val = 2.0;

void
DoMoreExternStuff(void)
{
    std::cout << "In Two::DoMoreExternStuff" << std::endl;
}

void
DoMoreNonExternStuff(void)
{
    std::cout << "In Two::DoMoreNonExternStuff" << std::endl;
}

void
DoStuff(void)
{
    std::cout << "In Two::DoStuff, val=" << val << std::endl;
    DoMoreExternStuff();
    DoMoreNonExternStuff();
}

