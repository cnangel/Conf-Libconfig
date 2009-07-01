package Conf::Libconfig;

use 5.006001;
use warnings;
use strict;
use vars qw/@ISA $VERSION @EXPORT %EXPORT_TAGS @EXPORT_OK/;

use Carp;

require Exporter;
@ISA = qw(Exporter);

=head1 NAME

Conf::Libconfig - The great new Conf::Libconfig!

=head1 VERSION

Version 0.01

=cut

$VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

=over 

Perhaps a little code snippet.

    use Conf::Libconfig;
    my $foo = Conf::Libconfig->new();
or
    my $foo = new Conf::Libconfig;
    ...

=back

=head2 new 

=cut

sub new 
{
	my $class = shift;
	my $self = {
		'config' => {},
	};
	eval {
		require XSLoader;
		XSLoader::load('Conf::Libconfig', $VERSION);
		1;
	} or do {
		require DynaLoader;
		push @ISA, 'DynaLoader';
		bootstrap Conf::Libconfig $VERSION;
	};
	bless $self, $class;
	return $self;
}

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 init

=cut

sub init
{
	my $self = shift;
	config_init($self->config);
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

cnangel, C<< <junliang.li at alibaba-inc.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-conf-libconfig at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Conf-Libconfig>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Conf::Libconfig


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Conf-Libconfig>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Conf-Libconfig>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Conf-Libconfig>

=item * Search CPAN

L<http://search.cpan.org/dist/Conf-Libconfig/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 cnangel, all rights reserved.

This program is released under the following license: bsd


=cut

1; # End of Conf::Libconfig
