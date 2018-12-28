# Copyright (c) 2018, cPanel, LLC.
# All rights reserved.
# http://cpanel.net
#
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself. See L<perlartistic>.

package Colon::Config;

use strict;
use warnings;

# ABSTRACT: XS helper to read a configuration file using ':' as separator


BEGIN {

    # VERSION: generated by DZP::OurPkgVersion

    require XSLoader;
    XSLoader::load(__PACKAGE__);
}

sub read_pp {
    my ( $config ) = @_;

    return [ map { ( split( m{:\s+}, $_ ) )[ 0, 1 ] } split( m{\n}, $config ) ];
}

sub read_as_hash {
    my ( $config, $field ) = @_;

    $field = 0 unless defined $field;

    my $av = Colon::Config::read($config, $field );
    return unless $av;

    return { @$av };
}


1;

=pod

=encoding utf-8

=head1 SYNOPSIS

Colon::Config sample usage

# EXAMPLE: examples/synopsis.pl

=head1 DESCRIPTION

Colon::Config

XS helper to read a configuration file using ':' as separator
(could be customize later)

This right now pretty similar to a double split like this one

    [ map { ( split( m{:\s+}, $_ ) )[ 0, 1 ] } split( m{\n}, $string ) ];

=head1 Basic parsing rules

=over

=item ':' is the default character separator between key and value 

=item spaces or tab characters after ':' are ignored

=item '#' indicates the beginning of a comment line

=item spaces or tab characters before a comment '#' are ignored

=item '\n' is used for detecting 'End Of line'

=back

=head1 Available functions

=head2 read( $content )

Parse the string $content and return an Array Ref with the list of key/values parsed.

Note: return undef when not called with a string

=head2 read_as_hash( $content )

This helper is provided as a convenient feature if want to manipulate the Array Ref
from read as a Hash Ref.

=head1 Benchmark

Here are some benchmarks to check the advantage of the XS helper, against a pure perl alternative.

# EXAMPLE: examples/benchmark.t

=head1 TODO

=over

=item support for custom characters: separator, end of line, spaces, ...

=back

=head1 LICENSE

This software is copyright (c) 2018 by cPanel, Inc.

This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming
language system itself.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY
APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE
SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE
OF THE SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY
WHO MAY MODIFY AND/OR REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE LIABLE TO YOU FOR DAMAGES,
INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR
THIRD PARTIES OR A FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF SUCH HOLDER OR OTHER PARTY HAS
BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

