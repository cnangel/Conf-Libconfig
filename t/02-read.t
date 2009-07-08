#!perl -T

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 13;

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

my $settings = $foo->setting_lookup("application.group1.states");
ok(($settings ? 1 : 0), "setting lookup - status ok");

my $settings_length = $settings->length();
ok(($settings_length ? 1 : 0), "setting length - status ok");

warn "\n";
warn "-"x50;
my $item;
for (0..$settings_length-1)
{
	$item = $settings->get_item($_);
	diag $item;
	ok(($item ? 1 : 0), "item test");
}
warn "-"x50;
