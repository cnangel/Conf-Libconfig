use strict;
use lib '.';
use inc::Module::Install;

name     'Conf-Libconfig';
all_from 'lib/Conf/Libconfig.pm';
author   'cnangel <junliang.li@alibaba-inc.com>';
license  'bsd';

#build_requires 'Test::More';
build_requires      ('Test::Base' => '0.01');

auto_install;

WriteAll;

