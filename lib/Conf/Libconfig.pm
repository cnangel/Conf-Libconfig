package Conf::Libconfig;

use 5.006001;
use strict;
use warnings;

our $VERSION = '0.006';

require XSLoader;
XSLoader::load('Conf::Libconfig', $VERSION);

1;
__END__
=head1 NAME

Conf::Libconfig - Perl extension for libconfig

=head1 SYNOPSIS

  use Conf::Libconfig;
  my $self = new Conf::Libconfig;
  $self->read_file($cfg);
  my $value = $self->lookup_value("abc.edf");
  print $value;
  $self->delete();

=head1 DESCRIPTION

The module C<Conf::Libconfig> need use libconfig library:

    http://www.hyperrealm.com/libconfig/

You can use C<Conf::Libconfig> for perl config, and support Salar, Array and Hash data struction etc.
like C or C++ function. C<Conf::Libconfig> could reduce your config file and quote by C/C++ transportability.

=head2 EXPORT

None by default.

=head2 $self->new()

Construct.

=head2 $self->delete()

Destructor.

=head2 $self->read_file ($file)

Read config file.

=head2 $self->write($buffer)

write to a handle buffer.

=head2 $self->write_file($filename)

write to a file.

=head2 $self->lookup_value ($path)

Autocheck and get value from config file, suggest use it.

=head2 $self->setting_lookup ($path)

return setting resource.

=head2 $self->fetch_array ($path)

return array list from path.

=head2 $self->fetch_hashref ($path)

return hash refenrece from path.

=head2 $setting->length ()

return count of setting resource.

=head2 $setting->get_item ($i)

return value of the $i item.

=head2 $self->lookup_bool ($path)

Only get value type of bool from config file, please use lookup_value replace it.

=head2 $self->lookup_int ($path)

Only get value type of long int from config file, please use lookup_value replace it.

=head2 $self->lookup_int64 ($path)

Only get value type of long long int from config file, please use lookup_value replace it.

=head2 $self->lookup_float ($path)

Only get value type of float from config file, please use lookup_value replace it.

=head2 $self->lookup_string ($path)

Only get value type of string from config file, please use lookup_value replace it.

=head1 PREREQUISITES

This module uses libconfig.

=head1 INSTALLATION

To prepare install, you should install libconfig, you can use yum for redhat,
like this:

    yum install libconfig libconfig-devel -y

or apt-get for debian:

    apt-get libconfig libconfig-devel

for other platform, you can compiler libconfig from source:

    http://www.hyperrealm.com/libconfig/

you can use order like this:

    wget http://www.hyperrealm.com/libconfig/libconfig-1.3.2.tar.gz
    tar -zxf libconfig-1.3.2.tar.gz
    cd libconfig-1.3.2
    ./configure --prefix=/usr
    make
    make install

If you are not soudoer or root, you need contact administrator.

    perl Makefile.PL
    make
    make test
    make install

Win32 users should replace "make" with "nmake".

=head1 SOURCE CONTROL

You can always get the latest Conf::Libconfig source from its
public Git repository:

    http://github.com/cnangel/Conf-Libconfig/tree/master

If you have a branch for me to pull, please let me know ;)

=head1 TODO

=over

=item *

Support xml config and yaml config.

=back

=head1 SEE ALSO

You can compare this module L<Conf::Libconfig> to L<Config>, L<Config::General>, L<Config::JSON>.

http://my.huhoo.net/

=head1 AUTHOR

Cnangel, E<lt>cnangel@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

This module as well as its programs are licensed under the BSD License.

Copyright (c) 2009, Alibaba Search Center, Alibaba Inc. All rights reserved.

Copyright (C) 2009 by cnangel

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

=over

=item *

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

=item *

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

=item *

Neither the name of the Alibaba Search Center, Alibaba Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

=back

=head2 DISCLAIMER OF WARRANTY

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
