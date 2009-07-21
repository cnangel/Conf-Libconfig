#!perl -T
use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 3;

use Conf::Libconfig;

my $cfgfile = "./t/test.cfg";
my $writecfgfile = "./t/newtest.cfg";
my $foo = Conf::Libconfig->new;
ok($foo->read_file($cfgfile), "read file - status ok");
open my $fp, '>', $writecfgfile or die "Can't write the file: $!";

#TODO: {
#local $TODO = 'write* methods do not work yet';

eval { $foo->write($fp) };
ok(($@ ? 0 : 1), "write buffer - status ok");

is(
    $foo->write_file($writecfgfile),
    1,
    "write file - status ok",
);

#}

close($fp);
unlink $writecfgfile;
