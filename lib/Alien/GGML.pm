package Alien::GGML;

use 5.010;
use strict;
use warnings;
use parent qw(Alien::Base);

our $VERSION = '0.001';

1;

__END__

=head1 NAME

Alien::GGML - Find or build the ggml tensor library

=head1 SYNOPSIS

    use ExtUtils::MakeMaker;
    use Alien::Base::Wrapper ();

    WriteMakefile(
        Alien::Base::Wrapper->new('Alien::GGML')->mm_args2(
            NAME => 'PDL::ML::Engine::GGML',
        ),
    );

Or at runtime with FFI::Platypus:

    use FFI::Platypus;
    use Alien::GGML;

    my $ffi = FFI::Platypus->new(
        api => 2,
        lib => [ Alien::GGML->dynamic_libs ],
    );

=head1 DESCRIPTION

This distribution provides the C<ggml> tensor computation library so that it can
be used by other Perl and L<PDL> distributions (including future C<cgraph>
broadcastloop pluggability). If C<ggml> is already installed on the system and
discoverable via C<pkg-config>, C<Alien::GGML> uses the system library;
otherwise it downloads and builds C<ggml> from source using CMake.

=head1 METHODS

Inherits all methods from L<Alien::Base>, including C<cflags>, C<libs>,
C<dynamic_libs>, and C<version>.

=head1 AUTHOR

C.J. Collier E<lt>cjac@google.comE<gt>

=head1 LICENSE

Apache-2.0

=cut
