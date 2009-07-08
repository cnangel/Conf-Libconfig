// vi:filetype=c

#ifdef __cplusplus
extern "C" {
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifdef __cplusplus
}
#endif

#define DDD(x)

#ifndef DDD
#define DDD(x) fprintf(stderr, "%s\n", x);
#endif

#ifndef NULL
#define NULL (void*)0
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef BOOL
#define BOOL short int
#endif

#include <libconfig.h++>
using namespace libconfig;

MODULE = Conf::Libconfig     PACKAGE = Conf::Libconfig

Config *
Config::new()

void
Config::DESTROY()

void 
Config::readFile(const char *filename)

bool 
Config::lookupValue(const char *path, int value)


