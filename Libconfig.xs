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
typedef config_setting_t *Conf__Libconfig__Settings;
config_t config;

void get_scalar(config_setting_t *, SV **);
void get_array(config_setting_t *, SV **);
void get_list(config_setting_t *, SV **);
void get_group(config_setting_t *, SV **);
int get_hashvalue(config_setting_t *, HV *);
int get_arrayvalue(config_setting_t *, AV *);

void
get_scalar(config_setting_t *settings, SV **svref)
{
	if (settings == NULL)
	{
		Perl_warn(aTHX_ "[WARN] Settings is null");
	}
    long long vBigint;
    char vBigintArr[256];
    size_t vBigintArrLen;
    const char *vChar;
    switch (settings->type)
    {
        case CONFIG_TYPE_INT:
            *svref = newSViv(config_setting_get_int(settings));
            break;
        case CONFIG_TYPE_INT64:
            vBigint = config_setting_get_int64(settings);
            vBigintArrLen = sprintf(vBigintArr, "%lld", vBigint);
            *svref = newSVpv(vBigintArr, vBigintArrLen);
            break;
        case CONFIG_TYPE_BOOL:
            *svref = newSViv(config_setting_get_bool(settings));
            break;
        case CONFIG_TYPE_FLOAT:
            *svref = newSVnv(config_setting_get_float(settings));
            break;
        case CONFIG_TYPE_STRING:
            vChar = config_setting_get_string(settings);
            *svref = newSVpvn(vChar, strlen(vChar));
            break;
        default:
            Perl_croak(aTHX_ "Scalar have not this type!");
    }
}


void 
get_array(config_setting_t *settings, SV **svref)
{
	if (settings == NULL)
	{
		Perl_warn(aTHX_ "[WARN] Settings is null");
	}
	int settings_count = config_setting_length(settings);

	SV *sv = newSV(0);
    AV *av = newAV();

	config_setting_t *settings_item;
	int i;
	for (i = 0; i < settings_count; i ++)
	{
		settings_item = config_setting_get_elem(settings, i);
		if (settings_item)
		{
			if (settings_item->name != NULL)
			{
				Perl_warn(aTHX_ "[WARN] It is not array, skip.");
			}
			switch (settings_item->type)
			{
				case CONFIG_TYPE_INT:
				case CONFIG_TYPE_INT64:
				case CONFIG_TYPE_BOOL:
				case CONFIG_TYPE_FLOAT:
				case CONFIG_TYPE_STRING:
					get_scalar(settings_item, &sv);
					av_push(av, sv);
					break;
				case CONFIG_TYPE_ARRAY:
					get_array(settings_item, &sv);
					av_push(av, sv);
					break;
				case CONFIG_TYPE_LIST:
					get_list(settings_item, &sv);
					av_push(av, sv);
					break;
				case CONFIG_TYPE_GROUP:
					get_group(settings_item, &sv);
					av_push(av, sv);
					break;
				default:
					Perl_croak(aTHX_ "Not this type!");
			}
		}
	}
	*svref = newRV_noinc((SV *)av);
}

void
get_list(config_setting_t *settings, SV **svref)
{
	get_array(settings, svref);
}

void
get_group(config_setting_t *settings, SV **svref)
{
	if (settings == NULL)
	{
		Perl_warn(aTHX_ "[WARN] Settings is null");
	}
	int settings_count = config_setting_length(settings);

	SV *sv = newSV(0);
	HV *hv = newHV();

	config_setting_t *settings_item;
	int i;
	for (i = 0; i < settings_count; i ++)
	{
		settings_item = config_setting_get_elem(settings, i);
		if (settings_item)
		{
			switch (settings_item->type)
			{
				case CONFIG_TYPE_INT:
				case CONFIG_TYPE_INT64:
				case CONFIG_TYPE_BOOL:
				case CONFIG_TYPE_FLOAT:
				case CONFIG_TYPE_STRING:
					get_scalar(settings_item, &sv);
					if (!hv_store(hv, settings_item->name, strlen(settings_item->name), sv, 0))
					{
						Perl_warn(aTHX_ "[Notice] it is some wrong with saving simple type in hv.");
					}
					break;
				case CONFIG_TYPE_ARRAY:
					get_array(settings_item, &sv);
					if (!hv_store(hv, settings_item->name, strlen(settings_item->name), sv, 0))
					{
						Perl_warn(aTHX_ "[Notice] it is some wrong with array type in hv.");
					}
					break;
				case CONFIG_TYPE_LIST:
					get_list(settings_item, &sv);
					if (!hv_store(hv, settings_item->name, strlen(settings_item->name), sv, 0))
					{
						Perl_warn(aTHX_ "[Notice] it is some wrong with list type in hv.");
					}
					break;
				case CONFIG_TYPE_GROUP:
					get_group(settings_item, &sv);
					if (!hv_store(hv, settings_item->name, strlen(settings_item->name), sv, 0))
					{
						Perl_warn(aTHX_ "[Notice] it is some wrong with group type in hv.");
					}
					break;
				default:
					Perl_croak(aTHX_ "Not this type!");
			}
		}
	}
	*svref = newRV_noinc((SV *)hv);
}

int 
get_arrayvalue(config_setting_t *settings, AV *av)
{
	if (settings == NULL) return 1;
	int settings_count = config_setting_length(settings);

	SV *sv = newSV(0);

	config_setting_t *settings_item;
	int i;
	for (i = 0; i < settings_count; i ++)
	{
		settings_item = config_setting_get_elem(settings, i);
		if (settings_item)
		{
			switch (settings_item->type)
			{
				case CONFIG_TYPE_INT:
				case CONFIG_TYPE_INT64:
				case CONFIG_TYPE_BOOL:
				case CONFIG_TYPE_FLOAT:
				case CONFIG_TYPE_STRING:
					get_scalar(settings_item, &sv);
					av_push(av, sv);
					break;
				case CONFIG_TYPE_ARRAY:
					get_array(settings_item, &sv);
					av_push(av, sv);
					break;
				case CONFIG_TYPE_LIST:
					get_list(settings_item, &sv);
					av_push(av, sv);
					break;
				case CONFIG_TYPE_GROUP:
					get_group(settings_item, &sv);
					av_push(av, sv);
					break;
				default:
					Perl_croak(aTHX_ "Not this type!");
			}
		}
	}
	return 0;
}

int
get_hashvalue(config_setting_t *settings, HV *hv)
{
	if (settings == NULL) return 1;
	int settings_count = config_setting_length(settings);

	SV *sv = newSV(0);

	config_setting_t *settings_item;
	int i;
	for (i = 0; i < settings_count; i ++)
	{
		settings_item = config_setting_get_elem(settings, i);
		if (settings_item)
		{
			switch (settings_item->type)
			{
				case CONFIG_TYPE_INT:
				case CONFIG_TYPE_INT64:
				case CONFIG_TYPE_BOOL:
				case CONFIG_TYPE_FLOAT:
				case CONFIG_TYPE_STRING:
					get_scalar(settings_item, &sv);
					if (!hv_store(hv, settings_item->name, strlen(settings_item->name), sv, 0))
					{
						Perl_warn(aTHX_ "[Notice] it is some wrong with saving simple type in hv.");
					}
					break;
				case CONFIG_TYPE_ARRAY:
					get_array(settings_item, &sv);
					if (!hv_store(hv, settings_item->name, strlen(settings_item->name), sv, 0))
					{
						Perl_warn(aTHX_ "[Notice] it is some wrong with array type in hv.");
					}
					break;
				case CONFIG_TYPE_LIST:
					get_list(settings_item, &sv);
					if (!hv_store(hv, settings_item->name, strlen(settings_item->name), sv, 0))
					{
						Perl_warn(aTHX_ "[Notice] it is some wrong with list type in hv.");
					}
					break;
				case CONFIG_TYPE_GROUP:
					get_group(settings_item, &sv);
					if (!hv_store(hv, settings_item->name, strlen(settings_item->name), sv, 0))
					{
						Perl_warn(aTHX_ "[Notice] it is some wrong with group type in hv.");
					}
					break;
				default:
					Perl_croak(aTHX_ "Not this type!");
			}
		}
	}
	return 0;
}

MODULE = Conf::Libconfig     PACKAGE = Conf::Libconfig  PREFIX = libconfig_

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
        SV *sv = newSV(0);
    CODE:
    {
        if (config_lookup_int(conf, path, &valueInt))
            sv = newSViv((int)valueInt);
        else if (config_lookup_string(conf, path, (const char **)&valueChar))
            sv = newSVpvn(valueChar, strlen(valueChar));
        else if (config_lookup_float(conf, path, &valueFloat))
            sv = newSVnv(valueFloat);
        else if (config_lookup_bool(conf, path, &valueBool))
            sv = newSViv(valueBool);
        else if (config_lookup_int64(conf, path, &valueBigint))
        {
            valueBigintArrLen = sprintf(valueBigintArr, "%lld", valueBigint);
            sv = newSVpv(valueBigintArr, valueBigintArrLen);
        }
        RETVAL = sv;
    }
    OUTPUT:
        RETVAL

AV *
libconfig_fetch_array(conf, path)
    Conf::Libconfig conf
    const char *path
    PREINIT:
        config_setting_t *settings;
        AV *av = newAV();
    CODE:
    {
        settings = config_lookup(conf, path);
        get_arrayvalue(settings, av);
        RETVAL = av;
    }
    OUTPUT:
        RETVAL

HV *
libconfig_fetch_hashref(conf, path)
    Conf::Libconfig conf
    const char *path
    PREINIT:
        config_setting_t *settings;
        HV *hv = newHV();
    CODE:
    {
        settings = config_lookup(conf, path);
        get_hashvalue(settings, hv);
		/*sv_bless (newRV_noinc ((SV*) *hvref), gv_stashpv ("Conf::Libconfig", TRUE));*/
		RETVAL = hv;
    }
    OUTPUT:
        RETVAL


Conf::Libconfig::Settings
libconfig_setting_lookup(conf, path)
    Conf::Libconfig conf
    const char *path
    PREINIT:
    CODE:
    {
        RETVAL = config_lookup(conf, path);
    }
    OUTPUT:
        RETVAL

void
libconfig_write(conf, stream)
	Conf::Libconfig conf
	FILE *stream
	PREINIT:
	CODE:
		config_write(conf, stream);

int
libconfig_write_file(conf, filename)
	Conf::Libconfig conf
	const char *filename
	PREINIT:
	CODE:
	{
		RETVAL = config_write_file(conf, filename);
	}
	OUTPUT:
		RETVAL

int 
libconfig_add_scalar(conf, path, scalar)
	Conf::Libconfig conf
    const char *path
	SV *scalar
	CODE:
		RETVAL = 1;
	OUTPUT:
		RETVAL

int 
libconfig_add_array(conf, path, array)
	Conf::Libconfig conf
    const char *path
	AV *array
	CODE:
		RETVAL = 1;
	OUTPUT:
		RETVAL

int 
libconfig_add_list(conf, path, list)
	Conf::Libconfig conf
    const char *path
	AV *list
	CODE:
		RETVAL = 1;
	OUTPUT:
		RETVAL

int 
libconfig_add_hash(conf, path, hash)
	Conf::Libconfig conf
    const char *path
	HV *hash
	CODE:
		RETVAL = 1;
	OUTPUT:
		RETVAL

int
libconfig_delete_node(conf, path)
    Conf::Libconfig conf
    const char *path
    CODE:
		RETVAL = 1;
    OUTPUT:
        RETVAL

MODULE = Conf::Libconfig     PACKAGE = Conf::Libconfig::Settings    PREFIX = libconfig_setting_

int
libconfig_setting_length(setting)
    Conf::Libconfig::Settings setting
    PREINIT:
    CODE:
    {
        RETVAL = config_setting_length(setting);
    }
    OUTPUT:
        RETVAL

SV *
libconfig_setting_get_item(setting, i)
    Conf::Libconfig::Settings setting
    int i
    PREINIT:
        const char *itemChar;
        double itemFloat;
        long long itemBigint;
        char itemBigintArr[256];
        STRLEN itemBigintArrLen;
        long itemInt;
        int itemBool;
        SV *sv = newSV(0);
    CODE:
    {
        if ((itemInt = config_setting_get_int_elem(setting, i)))
            sv = newSViv(itemInt);
        else if ((itemBigint = config_setting_get_int64_elem(setting, i)))
        {
            itemBigintArrLen = sprintf(itemBigintArr, "%lld", itemBigint);
            sv = newSVpv(itemBigintArr, itemBigintArrLen);
        }
        else if ((itemBool = config_setting_get_bool_elem(setting, i)))
            sv = newSViv(itemBool);
        else if ((itemFloat = config_setting_get_float_elem(setting, i)))
            sv = newSVnv(itemFloat);
        else if ((itemChar = config_setting_get_string_elem(setting, i)))
            sv = newSVpvn(itemChar, strlen(itemChar));
        RETVAL = sv;
    }
    OUTPUT:
        RETVAL

