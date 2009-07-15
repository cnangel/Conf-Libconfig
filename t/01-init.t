#!perl -T
use strict;
use warnings;
use Test::Exception tests => 1;
use Conf::Libconfig;

lives_ok { my $foo = Conf::Libconfig->new; } 'new - status ok';
