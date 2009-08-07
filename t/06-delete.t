#!perl -T
use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 3;
use Test::Deep;

use Conf::Libconfig;

my $cfgfile = "./t/spec.cfg";
my $foo = Conf::Libconfig->new;
ok($foo->read_file($cfgfile), "read file - status ok");

TODO: {
local $TODO = 'delete_* methods do not work yet';

ok($foo->delete_node("me.mar.family"), "delete node - status ok");

}

# Destructor
eval { $foo->delete() };
ok(($@ ? 0 : 1), "destructor - status ok");

