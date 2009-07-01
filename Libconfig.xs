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

MODULE = Conf::Libconfig     PACKAGE = Conf::Libconfig	PREFIX=libconfig_

PROTOTYPES: DISABLE

void 
config_init(config_t *config)
