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
	const char *file = "./t/spec.cfg";
	if (CONFIG_FALSE == config_read_file(&config, file))
	{
		fprintf(stderr, "Can't read file: %s", file);
		return 1;
	}
	const config_setting_t *array;
	array = config_lookup(&config, "me.arr");
	if (array)
	{
		int arrayLen = config_setting_length(array);
		printf("--------------------\n");
		printf("array size: %d\n", arrayLen);
		int i = 0;
		for(; i < arrayLen; i ++)
		{
			//printf("value [%i]: %s\n", i, config_setting_get_string_elem(array, i));
			printf("value [%i]: %ld\n", i, config_setting_get_int_elem(array, i));
		}
	}
	config_setting_t *setting;
	setting = config_lookup(&config, "me.mar");
	config_setting_t *child_set = config_setting_get_member(setting, "family");
	config_setting_t *child_set1 = config_setting_get_member(setting, "many");
	config_setting_t *child_set2 = config_setting_get_member(setting, "check");
	/*config_setting_t *child_set_child = config_setting_get_member(child_set2, "main");*/
	printf("--------------------------------\n");
	const char *many = config_setting_get_string(child_set1);
	const char *family = config_setting_get_string_elem(child_set, 0);
	printf("%s %s\n", many, family);
	int n = config_setting_index(setting);
	printf("n = %d\n", n);
	config_setting_t *newgroup = config_setting_add(child_set2, "we", CONFIG_TYPE_INT);
	printf("%d\n", config_setting_set_int(newgroup, 1234));
	config_setting_t *newarray = config_setting_add(child_set2, "nomain", 3);
	printf("%d\n", config_setting_set_int64(newarray, 12345L));
	int m = config_setting_remove(child_set2, "main");
	printf("m = %d\n", m);
	printf("%d\n", config_setting_remove(setting, "many"));
	printf("--------------------------------\n");
	config_setting_t *books_setting = config_lookup(&config, "books");
	printf("books: %s\n", config_setting_get_string_elem(books_setting, 0));
	printf("--------------------------------\n");
	const char *wfile = "./test.conf";
	if (CONFIG_FALSE == config_write_file(&config, wfile))
	{
		fprintf(stderr, "Can't write file: %s", wfile);
		return 1;
	}
	return 0;
}

