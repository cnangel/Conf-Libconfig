#!perl -T
use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 7;
use Test::Deep;

use Conf::Libconfig;

my $cfgfile = "./t/spec.cfg";
my $newcfgfile = "./t/newspec.cfg";
my $foo = Conf::Libconfig->new;
ok($foo->read_file($cfgfile), "read file - status ok");

my $key = "node1";
my $value = "hello, world";
my @arr = (1, 2, 3);
my @list = ("abc", 456, 0x888);
ok($foo->add_scalar("me.mar", $key, $value), "add scalar - status ok");
ok($foo->modify_scalar("me.mar.float", $value), "modify scalar - status ok");
$key = "node2";
ok($foo->add_array("me.mar", $key,  \@arr), "add array - status ok");

TODO: {
local $TODO = 'add_* methods do not work yet';

# like add_array
ok($foo->add_list("me.mar.family1", \@list), "add list - status ok");

my %hash = (1, 2, 3, 4);
$key = "node4";
ok($foo->add_hash("me.mar.check1", $key, \%hash), "add hash - status ok");

}

ok($foo->write_file($newcfgfile), "write file - status ok");
#unlink($newcfgfile);
