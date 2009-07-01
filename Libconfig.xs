// vi:filetype=c

#ifdef __cplusplus
extern "C" {
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "libconfig.h"

#ifdef __cplusplus
}
#endif

typedef struct config_t Conf_Libconfig;
config_t conf;

MODULE = Conf::Libconfig     PACKAGE = Conf::Libconfig	PREFIX=libconfig_
PROTOTYPES: DISABLE

config_t *
config_init()
	CODE:
		config_init(&conf);
		RETVAL = &conf;
	OUTPUT:
		RETVAL

int
config_read_file(config_t *config, const char *filename)

long 
config_lookup_int(const config_t *config, const char *path)



