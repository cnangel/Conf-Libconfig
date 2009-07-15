#!perl -T
use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 2;
use Test::Deep;

use Conf::Libconfig;

my $cfgfile = "./t/spec.cfg";
my $foo = Conf::Libconfig->new;

TODO: {
local $TODO = 'fetch_* methods do not work yet';

cmp_deeply(
    [$foo->fetch_array("me.mar.family")],
    [
        123, 456, 789, 0x111, undef, "xyz", [5, 2, 13],
        (43434.00001, "abcd", 12355666),
        { ok => "hello, world", b => [456, 0x456, undef], },
    ],
    "fetch array - status ok",
);

cmp_deeply(
    $foo->fetch_hashref("me.mar.check1"),
    {
        x => 0x20,
        m => [ 1, 2, 332 ],
    },
    "fetch hash - status ok",
);

}
