use strict;
use lib '.';
use inc::Module::Install;

name				'Conf-Libconfig';
license				'bsd';
author				'cnangel <junliang.li@alibaba-inc.com>';
perl_version        '5.006001';
all_from			'lib/Conf/Libconfig.pm';

requires			'ExtUtils::XSBuilder' => 0;
requires			'Cwd' => 1.00;
requires			'File::Find' => 1.00;

build_requires      'Test::Base' => '0.01';

#test_requires		'Test::Pod::Coverage' => '0';

cc_inc_paths		'/usr/include';
#cc_files			(glob("./src/*.c"));
cc_lib_paths		'/usr/lib';
cc_lib_links		'config';
#can_cc or die 'This module requires C compiler.';

use_test_base;

#no_index			( directory => qw< t inc xs xsbuilder src > );
no_index			( directory => qw< t inc src > );

#install_script      ('bin/ParseSource.pl');
#install_script      ('bin/WrapXSCheck.pl');
#install_script      ('bin/WrapXSRun.pl');

auto_install();

WriteAll();

#package MY;
#sub c_o
#{
	#my $src = shift->SUPER::c_o(@_);
	#my ($from, $to) = ('$(DEFINE) $*.', '$(DEFINE) -o $@ $*.');
	#$src =~ s{\Q$from\E}{$to}gxms;
	#return $src;
#}
