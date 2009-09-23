#!perl -T
use strict;
use warnings;
use Data::Dumper;
use Test::More;
use Test::Deep;

use Conf::Libconfig;

my $cfgfile = "./t/spec.cfg";
my $foo = Conf::Libconfig->new;
ok($foo->read_file($cfgfile), "read file - status ok");


done_testing();
