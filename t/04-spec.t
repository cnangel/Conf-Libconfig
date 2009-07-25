#!perl -T
use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 1;
use Test::Deep;

use Conf::Libconfig;

my $cfgfile = "./t/spec.cfg";
my $foo = Conf::Libconfig->new;
ok($foo->read_file($cfgfile), "read file - status ok");

# Check array method
warn Dumper $foo->fetch_array("me.mar.float");
cmp_deeply{
	[$foo->fetch_array("me.mar.float")],
	[
		num(3.1415926535, 1e-10),
	],
	"fetch scalar into array reference - status ok",
};

#cmp_deeply(
	#[$foo->fetch_array("me.mar.family")],
	#[
		#[ 123, 456, 789, 0x111, 0, "xyz",
			#[ 5, 2, 13 ], [ num(43434.00001,1e-5), "abcd", 12355666 ],
			#{ ok => "hello, world", b => [ 456, 0x456, 0 ] }
			#]
	#],
	#"fetch array into array reference - status ok",
#);

#cmp_deeply{
	#[$foo->fetch_array("me.mar.check1")],
	#[
		#32, [ 1, 2, 332 ], [ 'a', 'b', 'c' ],
		#[ 'this is world', ' now', 19821002 ],
		#{
		#'y' => '1000200300',
		#'z' => [
			#'new',
			#' paper'
			#]
		#},
		#[ 1, 96, '1234567890', [ 1, 2, 3 ], { 'xyz' => 1 } ]
	#],
	#"fetch group into array reference - status ok",
#};

#cmp_deeply(
	#[$foo->fetch_array("me.mar.check2")],
	#[ ],
	#"fetch empty group into array reference - status ok",
#);

## Check hash method
#cmp_deeply{
	#[$foo->fetch_hashref("me.mar.many")],
	#[
		#many =>	"ok, i have",
	#],
	#"fetch scalar into hash reference - status ok",
#};

##warn Dumper $foo->fetch_array("me.mar.check1");
#cmp_deeply{
	#[$foo->fetch_hashref("me.arr")],
	#[
		#many =>	"ok, i have",
	#],
	#"fetch array into hash reference - status ok",
#};

#cmp_deeply(
	#$foo->fetch_hashref("me.mar.check"),
	#{
		#main => [ 1, 2, 3, 4 ],
		#family => [
		 #[ "abc", 123, 1 ], num(1.234, 1e-4), [],
		 #[ 1, 2, 3 ], { a => [ 1, 2, 1 ] }
		#]
	#},
	#"fetch group into hash reference - status ok",
#);

#cmp_deeply(
	#$foo->fetch_hashref("me.mar.check2"),
    #{ },
	#"fetch empty group into hash reference - status ok",
#);

