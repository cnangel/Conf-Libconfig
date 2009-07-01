#!perl -T

use strict;
use warnings;
use Test::More tests => 1;

use Conf::Libconfig;


my $foo = new Conf::Libconfig;
$foo->read_file("/u/src/syncengine/conf/jsclient.cfg");

eval { use DBI; };
ok(($@ ? 0 : 1), "init - status ok");
