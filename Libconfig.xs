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

#define XS_STATE(type, x) \
	INT2PTR(type, SvROK(x) ? SvIV(SvRV(x)) : SvIV(x))

#define XS_STRUCT2OBJ(sv, class, obj) \
	if (obj == NULL) { \
		sv_setsv(sv, &PL_sv_undef); \
	} else { \
		sv_setref_pv(sv, class, (void *) obj); \
	}

#include <libconfig.h>

typedef config_t *Conf__Libconfig;
config_t config;

MODULE = Conf::Libconfig     PACKAGE = Conf::Libconfig	PREFIX = libconfig_

Conf::Libconfig
libconfig_new(packname="Conf::Libconfig")
	char *packname
	PREINIT:
	CODE:
	{
		config_init(&config);
		RETVAL = &config;
	}
	OUTPUT:
		RETVAL

void
libconfig_delete(conf)
	Conf::Libconfig conf
	CODE:
		config_destroy(conf);

int
libconfig_read_file(conf, filename)
	Conf::Libconfig conf
	const char *filename
	CODE:
	{
		RETVAL = config_read_file(conf, filename);
	}
	OUTPUT:
		RETVAL

long
libconfig_lookup_int(conf, path)
	Conf::Libconfig conf
	const char *path
	PREINIT:
		long value;
	CODE:
	{
		config_lookup_int(conf, path, &value);
		RETVAL = value;
	}
	OUTPUT:
		RETVAL

SV * 
libconfig_lookup_int64(conf, path)
	Conf::Libconfig conf
	const char *path
	PREINIT:
		long long int value;
		char valueArr[256];
		STRLEN valueArrLen;
	CODE:
	{
		config_lookup_int64(conf, path, &value);
		valueArrLen = sprintf(valueArr, "%lld", value);
		RETVAL = newSVpv(valueArr, valueArrLen);
	}
	OUTPUT:
		RETVAL

int
libconfig_lookup_bool(conf, path)
	Conf::Libconfig conf
	const char *path
	PREINIT:
		int value;
	CODE:
	{
		config_lookup_bool(conf, path, &value);
		RETVAL = value;
	}
	OUTPUT:
		RETVAL

double
libconfig_lookup_float(conf, path)
	Conf::Libconfig conf
	const char *path
	PREINIT:
		double value;
	CODE:
	{
		config_lookup_float(conf, path, &value);
		RETVAL = value;
	}
	OUTPUT:
		RETVAL

char *
libconfig_lookup_string(conf, path)
	Conf::Libconfig conf
	const char *path
	PREINIT:
		char *value;
	CODE:
	{
		config_lookup_string(conf, path, (const char **)&value);
		RETVAL = value;
	}
	OUTPUT:
		RETVAL

SV *
libconfig_lookup_value(conf, path)
	Conf::Libconfig conf
	const char *path
	PREINIT:
		long valueInt;
		long long valueBigint;
		char valueBigintArr[256];
		STRLEN valueBigintArrLen;
		int valueBool;
		char *valueChar;
		double valueFloat;
		SV *ret = newSV(0);
	CODE:
	{
		if (config_lookup_int(conf, path, &valueInt))
			ret = newSViv((int)valueInt);
		else if (config_lookup_string(conf, path, (const char **)&valueChar))
			ret = newSVpvn(valueChar, strlen(valueChar));
		else if (config_lookup_float(conf, path, &valueFloat))
			ret = newSVnv(valueFloat);
		else if (config_lookup_bool(conf, path, &valueBool))
			ret = newSViv(valueBool);
		else if (config_lookup_int64(conf, path, &valueBigint))
		{
			valueBigintArrLen = sprintf(valueBigintArr, "%lld", valueBigint);
			ret = newSVpv(valueBigintArr, valueBigintArrLen);
		}
		RETVAL = ret;
	}
	OUTPUT:
		RETVAL

MODULE = Conf::Libconfig     PACKAGE = Conf::Libconfig::Settings	PREFIX = libconfig_
