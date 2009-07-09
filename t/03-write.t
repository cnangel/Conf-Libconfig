#!perl -T

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 1;

use Conf::Libconfig;

my $cfgfile = "./t/test.cfg";
my $foo = new Conf::Libconfig;
my $r = $foo->read_file($cfgfile);
ok($r, "read file - status ok");

