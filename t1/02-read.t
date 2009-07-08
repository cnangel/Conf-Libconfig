#!perl -T

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 1;

use Conf::Libconfig;


my $conf = Conf::Libconfig::config_init();
#warn Dumper $conf;
ok(1);
#Conf::Libconfig::config_read_file($conf, "/home/cnangel/works/Conf-Libconfig/t/test.cfg");
#my $ret;
#Conf::Libconfig::config_lookup_int($conf, "application.ff", $ret);
#warn Dumper $ret;

#eval { use DBI; };
#ok(($@ ? 0 : 1), "init - status ok");
