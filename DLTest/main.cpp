#include <iostream>
#include <dlfcn.h>
#include "DLTestAPI.h"

int
main(int argc, char* argv[])
{
    int ret = 0;

    // Call a function from the shared library that we were linked with ("one").
    // This should execute the one in library "one."
    DoStuff();

    std::cout << "main: val=" << val << std::endl;

    // Dynamically load the other shared library ("two").
    // int loadflags = RTLD_LAZY;
    // int loadflags = RTLD_LAZY | RTLD_GLOBAL;
    int loadflags = RTLD_LAZY | RTLD_LOCAL;
    //auto libtwo = dlopen("libtwo.so", loadflags);
    auto libtwo = dlopen("./Two/libtwo.dylib", loadflags);
    if(libtwo != nullptr)
    {
        auto doStuffFunc = (void (*)(void))dlsym(libtwo, "DoStuff");
        if(doStuffFunc != nullptr)
        {
            // Call the function.  Which one gets executed?
            (*doStuffFunc)();
            std::cout << "main: val=" << val << std::endl;
        }
        else
        {
            std::cerr << "unable to find symbol DoStuff, " << dlerror() << std::endl;
            ret = 1;
        }
    }
    else
    {
        std::cerr << "unable to load libtwo, " << dlerror() << std::endl;
        ret = 1;
    }

    return ret;
}

