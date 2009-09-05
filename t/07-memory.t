#!perl -T
use strict;
use warnings;
use Data::Dumper;
use Test::More;
use Conf::Libconfig;

my $cfgfile = "./t/test.cfg";
my $difftime = 3;
my $conf = Conf::Libconfig->new;

ok($conf->read_file($cfgfile), "read file - status ok");

my ($settings, $setting_item, $test1, $test2, $test3, $test4, $test5, $test6, $test7, $test8);
my @items;

my $time = time();

while (1) {
	$test1 = $conf->lookup_value("application.test-comment");
	$test2 = $conf->lookup_value("application.test-long-string");
	$test3 = $conf->lookup_value("application.test-escaped-string");
	$test4 = $conf->lookup_value("application.window.title");
	$settings = $conf->setting_lookup("application.group1.states");
    push @items, $settings->get_item($_) for 0 .. $settings->length - 1;
	undef @items;
	$test5 = $settings->get_type();
	last if (time() - $time > $difftime); 
	$test6 = $conf->fetch_array("application.group1.my_array");
	$test7 = $conf->fetch_hashref("application.group1"),
}

# Destructor
eval { $conf->delete() };
ok(($@ ? 0 : 1), "destructor - status ok");

done_testing();
