#!perl -T
use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 5;
use Test::Deep;

use Conf::Libconfig;

my $cfgfile = "./t/spec.cfg";
my $foo = Conf::Libconfig->new;
ok($foo->read_file($cfgfile), "read file - status ok");

TODO: {
local $TODO = 'add_* methods do not work yet';

my $scalar = "hello, world";
ok($foo->add_scalar("me.mar.many", $scalar), "add scalar - status ok");

my @arr = (1, 2, 3);
ok($foo->add_array("me.arr", \@arr), "add array - status ok");

# like add_array
my @list = ("abc", 456, 0x888);
ok($foo->add_list("me.mar.family1", \@list), "add list - status ok");

my %hash = (1, 2, 3, 4);
ok($foo->add_hash("me.mar.check1", \%hash), "add hash - status ok");

}
