#!perl -T

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 2;

use Conf::Libconfig;

my $cfgfile = "./t/spec.cfg";
my $foo = new Conf::Libconfig;
my $r = $foo->read_file($cfgfile);
ok($r, "read file - status ok");

my $settings = $foo->setting_lookup("me.arr");

ok(($settings ? 1 : 0), "setting lookup - status ok");

my $len = $settings->length();

my $v = $settings->get_item(0);
diag $v;



