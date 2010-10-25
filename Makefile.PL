use strict;
use lib '.';
use inc::Module::Install;

test_requires		'ExtUtils::PkgConfig' => 0;

use ExtUtils::PkgConfig;
#use Devel::CheckLib qw(check_lib_or_exit);

name                'Conf-Libconfig';
license             'bsd';
author              'Cnangel <cnangel@gmail.com>';
all_from            'lib/Conf/Libconfig.pm';
#requires            'ExtUtils::XSBuilder' => 0;
#requires            'Cwd' => 1.00;
#requires            'File::Find' => 1.00;
requires            'XSLoader' => 0.05;

configure_requires  'ExtUtils::PkgConfig';


test_requires       'Test::Deep' => 0.10;
test_requires       'Test::More' => 0.90;
test_requires       'Test::Warn' => 0.20;
test_requires       'Test::Exception' => 0.25;
#test_requires       'Test::Spelling' => 0.10;
#check_lib_or_exit   lib => [qw(config)];

my @inc_paths = map { s/-I//; $_ } split(' ', ExtUtils::PkgConfig->cflags_only_I('libconfig'));
my @lib_paths = map { s/-L//; $_ } split(' ', ExtUtils::PkgConfig->libs_only_L('libconfig'));
cc_inc_paths        @inc_paths;
cc_lib_paths        @lib_paths;
cc_lib_links        'config';
checklibs		    lib => [qw(config)], header => [qw(libconfig.h)],
                    incpath => \@inc_paths, libpath => \@lib_paths;
can_cc              or die 'This module requires C compiler.';
no_index            directory => qw(t inc);
auto_install();
repository			'http://github.com/cnangel/Conf-Libconfig';
WriteAll();
