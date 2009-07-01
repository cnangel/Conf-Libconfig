#!perl -T

use strict;
use warnings;
use Test::More tests => 2;

use Conf::Libconfig;


eval {
	my $foo = new Conf::Libconfig;
};
ok(($@ ? 0 : 1), "new - status ok");

$foo->init(); 
