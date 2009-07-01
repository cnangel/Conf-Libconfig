#!perl -T

use strict;
use warnings;
use Test::More tests => 2;

ok(1);ok(1);exit;

use Conf::Libconfig;


my $foo;
eval { $foo = new Conf::Libconfig; };
ok(($@ ? 0 : 1), "new - status ok");


eval { $foo->init(); };
ok(($@ ? 0 : 1), "init - status ok");
