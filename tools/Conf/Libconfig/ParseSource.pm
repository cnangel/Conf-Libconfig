package Conf::Libconfig::ParseSource;

# export PERL5LIB=./lib

use strict;
use warnings;
use vars qw{@ISA $VERSION};

use Cwd;

@ISA = qw( ExtUtils::XSBuilder::ParseSource );

use base qw/ExtUtils::XSBuilder::ParseSource/;

$VERSION = '0.001';

my $cwd = cwd;
$cwd =~ m{^(.+/Conf-Libconfig).*$} or die "Can't find base directory";
my $basedir = $1;
my $srcdir = "$basedir/src";
my @dirs = ("$basedir/src");
my $basepackage = __PACKAGE__;
if ($basepackage =~ /(.*)::[^:]+/)
{
	$basepackage = $1;
}

sub find_includes 
{
	my $self = shift;
	return $self->{includes} if $self->{includes};
	require File::Find;
	my(@dirs) = @{$self->include_dirs};
	unless (-d $dirs[0]) {
		die "could not find include directory";
	}
# print "Will search @dirs for include files...\n" if ($verbose) ;
	my @includes;
	my $unwanted = join '|', @{$self -> unwanted_includes} ;

	for my $dir (@dirs) {
		File::Find::finddepth({
				wanted => sub {
				return unless /\.h$/;
				return if ($unwanted && (/^($unwanted)/o));
				my $dir = $File::Find::dir;
				push @includes, "$dir/$_";
				},
				follow => $^O ne 'MSWin32',
				}, $dir);
	}
	return $self->{includes} = $self -> sort_includes (\@includes) ;
}

sub include_dirs { \@dirs }

sub package { $basepackage }


1;
