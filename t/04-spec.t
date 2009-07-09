#!perl -T

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 5;

use Conf::Libconfig;

my $cfgfile = "./t/spec.cfg";
my $foo = new Conf::Libconfig;
my $r = $foo->read_file($cfgfile);
ok($r, "read file - status ok");

my $settings = $foo->setting_lookup("me.arr");

ok(($settings ? 1 : 0), "setting lookup - status ok");

my $len = $settings->length();

my $v = $settings->get_item(0);
ok(($v ? 1 : 0), "get item - status ok");

my @arr = $foo->fetch_array("me.mar.family");
warn Dumper \@arr;
ok((@arr ? 1 : 0), "fetch array - status ok");

my $ref = $foo->fetch_hashref("me.mar.check1");
warn Dumper $ref;

ok(1);


