#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "libconfig.h"

/*
 * gcc -I../include -L../lib -lconfig test.c -o test 
**/

int main(int argc, char *argv[])
{
	config_t config;
	config_init(&config);
	const char *file = "./t/test.cfg";
	if (CONFIG_FALSE == config_read_file(&config, file))
	{
		fprintf(stderr, "Can't read file: %s", file);
		exit;
	}
	long intValue;
	config_lookup_int(&config, "application.b", &intValue);
	printf("intValue is %ld\n", intValue);
	const config_setting_t *array;
	array = config_lookup(&config, "application.group1.states");
	if (array)
	{
		int arrayLen = config_setting_length(array);
		printf("--------------------\n");
		printf("array size: %d\n", arrayLen);
		int i = 0;
		for(; i < arrayLen; i ++)
		{
			printf("value [%i]: %s\n", i, config_setting_get_string_elem(array, i));
		}
	}
	return 0;
}

