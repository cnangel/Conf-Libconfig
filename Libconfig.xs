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


SV * check_array_type(config_setting_t *);
SV * check_hash_type(config_setting_t *, char **);
AV * get_array(config_setting_t *);
HV * get_hash(config_setting_t *, char *);

SV *
check_array_type(config_setting_t *settings)
{
    long long vBigint;
    char vBigintArr[256];
    size_t vBigintArrLen;
    const char *vChar;
    SV *sv = newSV(0);
    // Init hh
    /*char *name = config_setting_name(settings);*/
    /*hh->name = sv_setpvn(name, strlen(name));*/
    int settings_type = config_setting_type(settings);
    switch (settings_type)
    {
        case CONFIG_TYPE_INT:
            sv = newSViv(config_setting_get_int(settings));
            break;
        case CONFIG_TYPE_INT64:
            vBigint = config_setting_get_int64(settings);
            vBigintArrLen = sprintf(vBigintArr, "%lld", vBigint);
            sv = newSVpv(vBigintArr, vBigintArrLen);
            break;
        case CONFIG_TYPE_BOOL:
            sv = newSViv(config_setting_get_bool(settings));
            break;
        case CONFIG_TYPE_FLOAT:
            sv = newSVnv(config_setting_get_float(settings));
            break;
        case CONFIG_TYPE_STRING:
            vChar = config_setting_get_string(settings);
            sv = newSVpvn(vChar, strlen(vChar));
            break;
        default:
            Perl_croak(aTHX_ "Scalar have not this type!");
    }
    return sv;
}

SV *
check_hash_type(config_setting_t *settings, char **name)
{
    long long vBigint;
    char vBigintArr[256];
    size_t vBigintArrLen;
    const char *vChar;
    SV *sv = newSV(0);
    *name = config_setting_name(settings);
    int settings_type = config_setting_type(settings);
    switch (settings_type)
    {
        case CONFIG_TYPE_INT:
            sv = newSViv(config_setting_get_int(settings));
            break;
        case CONFIG_TYPE_INT64:
            vBigint = config_setting_get_int64(settings);
            vBigintArrLen = sprintf(vBigintArr, "%lld", vBigint);
            sv = newSVpv(vBigintArr, vBigintArrLen);
            break;
        case CONFIG_TYPE_BOOL:
            sv = newSViv(config_setting_get_bool(settings));
            break;
        case CONFIG_TYPE_FLOAT:
            sv = newSVnv(config_setting_get_float(settings));
            break;
        case CONFIG_TYPE_STRING:
            vChar = config_setting_get_string(settings);
            sv = newSVpvn(vChar, strlen(vChar));
            break;
        default:
            Perl_croak(aTHX_ "Scalar have not this type!");
    }
    return sv;
}

AV *
get_array(config_setting_t *settings)
{
    /*SV *sv = newSV(0);*/
    AV *av = newAV();
    AV *tmpav = newAV();
    int i;
    config_setting_t *settings_item;
    int settings_count;

    if (settings)
    {
        settings_count = config_setting_length(settings);
        for (i = 0; i < settings_count; i ++)
        {
            settings_item = config_setting_get_elem(settings, i);
            if (settings_item)
            {
                int settings_item_type = config_setting_type(settings_item);
                switch (settings_item_type)
                {
                    case CONFIG_TYPE_INT:
                    case CONFIG_TYPE_INT64:
                    case CONFIG_TYPE_BOOL:
                    case CONFIG_TYPE_FLOAT:
                    case CONFIG_TYPE_STRING:
                        av_push(av, check_array_type(settings_item));
                        break;
                    case CONFIG_TYPE_ARRAY:
                        tmpav = get_array(settings_item);
                        av_push(av, newRV_inc((SV*)tmpav));
                        break;
                    case CONFIG_TYPE_LIST:
                        tmpav = get_array(settings_item);
                        av_push(av, newRV_noinc((SV*)tmpav));
                        break;
                    case CONFIG_TYPE_GROUP:
                        tmpav = get_array(settings_item);
                        av_push(av, newRV_noinc((SV*)tmpav));
                        break;
                    default:
                        /*Perl_warn(aTHX_ "Common type!");*/
                        Perl_croak(aTHX_ "Not this type!");
                }
            }
        }
    }
    return av;
}

HV *
get_hash(config_setting_t *settings, char *name)
{
    SV *svvalue = newSV(0);
    /*char *name = NULL;*/
    HV *hv = newHV();
    /*AV *tmpav = newAV();*/
    /*HV *tmphv = newHV();*/
    int i;
    config_setting_t *settings_item;
    int settings_count;
    /*char *tmpchar;*/

            /*Perl_warn(aTHX_ "LIST this type!%s\n", settings->name);*/
    if (settings)
    {
        settings_count = config_setting_length(settings);
        for (i = 0; i < settings_count; i ++)
        {
            settings_item = config_setting_get_elem(settings, i);
            Perl_warn(aTHX_ "[Note] %s | %s => %d\n", settings->name, settings_item->name, i);
            if (settings_item)
            {
                int settings_item_type = config_setting_type(settings_item);
                switch (settings_item_type)
                {
                    case CONFIG_TYPE_INT:
                    case CONFIG_TYPE_INT64:
                    case CONFIG_TYPE_BOOL:
                    case CONFIG_TYPE_FLOAT:
                    case CONFIG_TYPE_STRING:
                        if (config_setting_name(settings_item))
                        {
                            svvalue = check_hash_type(settings_item, &name);
                            hv_store(hv, name, strlen(name), svvalue, 0);
                        }
                        else
                        {
                            Perl_croak(aTHX_ "Not anonymous this type!");
                            /*av_push(tmpav, check_array_type(settings_item));*/
                            /*tmpchar = sv_pv(check_array_type(settings_item));*/
                            /*hv_store(hv, tmpchar, strlen(tmpchar), 0, 0);*/
                            /*hv_store(hv, NULL, 0, newRV_inc((SV*)tmpav), 0);*/
                        }
                        // ??
                        /*hv_stores(hv, name, svvalue);*/
                        break;
                    case CONFIG_TYPE_ARRAY:
                        Perl_croak(aTHX_ "Not Array this type!");
                        /*tmphv = get_hash(settings_item, name);*/
                        /*hv_store(hv, name, strlen(name), newRV_inc((SV*)tmphv), 0);*/
                        break;
                    case CONFIG_TYPE_LIST:
                        /*tmpav = get_array(settings_item);*/
                        /*av_push(av, newRV_noinc((SV*)tmpav));*/
                        Perl_croak(aTHX_ "Not LIST this type!");
                        break;
                    case CONFIG_TYPE_GROUP:
                        /*tmpav = get_array(settings_item);*/
                        /*av_push(av, newRV_noinc((SV*)tmpav));*/
                        Perl_croak(aTHX_ "Not GROUP this type!");
                        break;
                    default:
                        /*Perl_warn(aTHX_ "Common type!");*/
                        Perl_croak(aTHX_ "Not this type!");
                }
            }
        }
    }
    return hv;
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
        av = get_array(settings);
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
        char name[256];
        HV *hv = newHV();
    CODE:
    {
        settings = config_lookup(conf, path);
        hv = get_hash(settings, name);
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

