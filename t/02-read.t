#!perl -T

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 6;

use Conf::Libconfig;

my $cfgfile = "./t/test.cfg";
my $foo = new Conf::Libconfig;
my $r = $foo->read_file($cfgfile);
ok($r, "read file - status ok");

$r = $foo->lookup_value("misc.enabled");
ok($r == 0, "bool test - status ok");

$r = $foo->lookup_value("application.a");
ok($r, "int test - status ok");

$r = $foo->lookup_value("misc.bigint");
ok($r, "bigint test - status ok");

$r = $foo->lookup_value("application.ff");
ok($r, "float test - status ok");

$r = $foo->lookup_value("application.test-comment");
ok($r, "string test - status ok");
