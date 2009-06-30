# vi:filetype=

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "libconfig.h"

MODULE = Conf::Libconfig     PACKAGE = Conf::Libconfig	PREFIX=libconfig_

PROTOTYPES: DISABLE

#ifdef __cplusplus
extern "C" {
#endif

void config_init(config_t *config)
	CODE:
	{
		RETVAL = config_init(config);
	}
	OUTPUT:
		RETVAL

#ifdef __cplusplus
}
#endif
