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

#TODO: {
#local $TODO = 'fetch_* methods do not work yet';

cmp_deeply(
	[$foo->fetch_array("me.mar.family")],
	[
		[ 123, 456, 789, 0x111, 0, "xyz",
			[ 5, 2, 13 ], [ num(43434.00001,1e-5), "abcd", 12355666 ],
			{ ok => "hello, world", b => [ 456, 0x456, 0 ] }
			]
	],
	"fetch array - status ok",
);

cmp_deeply(
	$foo->fetch_hashref("me.mar.check"),
	{
		main => [ 1, 2, 3, 4 ],
		family => [
		 [ "abc", 123, 1 ], num(1.234, 1e-4), [],
		 [ 1, 2, 3 ], { a => [ 1, 2, 1 ] }
		]
	},
	"fetch hash - status ok",
);

#}
