#!perl -T

use strict;
use warnings;
use Test::More tests => 1;

use Conf::Libconfig;

my $foo;
eval { $foo = Conf::Libconfig->new(); };
ok(($@ ? 0 : 1), "new - status ok");

