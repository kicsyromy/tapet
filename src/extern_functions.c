#include <stdio.h>

void my_app_debug_break ()
{
	__asm__("int3");
}
