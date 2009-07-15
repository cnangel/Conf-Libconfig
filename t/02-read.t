#!perl -T
use strict;
use warnings;
use bigint;
use Data::Dumper;
use Test::More tests => 9;

use Conf::Libconfig;

my $cfgfile = "./t/test.cfg";
my $foo = Conf::Libconfig->new;
ok($foo->read_file($cfgfile), "read file - status ok");

is(
    $foo->lookup_value("misc.enabled"),
    0,
    "bool test - status ok",
);

is(
    $foo->lookup_value("application.a"),
    5,
    "int test - status ok",
);

is(
    $foo->lookup_value("misc.bigint"),
    9223372036854775807,
    "bigint test - status ok",
);

is(
    $foo->lookup_value("application.ff"),
    1E6,
    "float test - status ok",
);

is(
    $foo->lookup_value("application.test-comment"),
    "/* hello\n \"there\"*/",
    "string test - status ok",
);

my $settings = $foo->setting_lookup("application.group1.states");
isa_ok($settings, 'Conf::Libconfig::Settings');

is(
    $settings->length,
    5,
    "setting length - status ok",
);

{
    my @items;
    push @items, $settings->get_item($_) for 0 .. $settings->length - 1;
    is_deeply(
        \@items,
        [qw(CT CA TX NV FL)],
        "item test",
    );
}
