use strict;
use lib '.';
use inc::Module::Install;

name				'Conf-Libconfig';
license				'bsd';
author				'cnangel <junliang.li@alibaba-inc.com>';
perl_version        '5.006001';
all_from			'lib/Conf/Libconfig.pm';

my $lcf = system("pkg-config libconfig --libs > /dev/null 2>&1");
if ($lcf != 0)
{
	printf("Please install libconfig from http://www.hyperrealm.com/libconfig/.\n");
	printf("You can install this lib in /usr/lib or /usr/local/lib, even you can edit Makefile.PL, \nand modify variable cc_lib_paths and cc_inc_paths where libconfig install.\n");
	printf("Default the Makefile.PL check this lib to use command: pkg-config, you could also instead it. \nCnangel (cnangel\@gmail.com)\n");
	printf("No Makefile for Conf::Libconfig\n");
	exit;
}
requires			'ExtUtils::XSBuilder' => 0;
requires			'Cwd' => 1.00;
requires			'File::Find' => 1.00;
requires			'XSLoader' => 0.05;

build_requires      'Test::Base' => '0.01';

#test_requires		'Test::Pod::Coverage' => '0';

#makemaker_args       CC    => 'g++';
#makemaker_args       LD    => 'g++';
#makemaker_args       XSOPT => '-C++';

cc_inc_paths		'/usr/include', '/usr/local/include';
#cc_files			(glob("./src/*.c"));
cc_lib_paths		'/usr/lib' , '/usr/lib64', '/usr/local/lib', '/usr/local/lib64';
#cc_lib_links		'config', 'config++';
cc_lib_links		'config';
can_cc				or die 'This module requires C compiler.';
#can_cc              or die 'This module requires C++ compiler.';
#cc_optimize_flags	'-g -Wall';

#use_test_base;

#auto_include_deps;

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
