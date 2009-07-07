#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <iostream>

#include "libconfig.h++"

/*
 * g++ -I../include -L../lib -lconfig++ test.c -o test 
**/

int main(int argc, char *argv[])
{
	libconfig::Config conf;
	const char *file = "./t/test.cfg";
	conf.readFile(file);
	long intValue;
	if (conf.lookupValue("application.b", intValue))
	{
		std::cout << "ok:" << intValue << std::endl;
	}
	else
	{
		std::cout << "fail" << std::endl;
	}
	return 0;
}

