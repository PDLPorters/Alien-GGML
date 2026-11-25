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

=head1 TUTORIAL

=head2 Consuming Alien::GGML in an XS Distribution

Use L<Alien::Base::Wrapper> in your F<Makefile.PL> to automatically inject the
compiler and linker flags required to build against C<ggml>:

    use strict;
    use warnings;
    use ExtUtils::MakeMaker;
    use Alien::Base::Wrapper ();

    WriteMakefile(
        Alien::Base::Wrapper->new('Alien::GGML')->mm_args2(
            NAME          => 'PDL::ML::Engine::GGML',
            VERSION_FROM  => 'lib/PDL/ML/Engine/GGML.pm',
            CONFIGURE_REQUIRES => {
                'Alien::Base::Wrapper' => '0',
                'Alien::GGML'          => '0.001',
                'ExtUtils::MakeMaker'  => '6.52',
            },
        ),
    );

In your XS file, include C<E<lt>ggml.hE<gt>> and call the C<ggml> C API directly:

    #include "EXTERN.h"
    #include "perl.h"
    #include "XSUB.h"
    #include <ggml.h>

    MODULE = My::GGML PACKAGE = My::GGML

    int
    check_ggml_init(klass)
        const char *klass
        CODE:
            struct ggml_init_params params = { 1024 * 1024, NULL, false };
            struct ggml_context *ctx = ggml_init(params);
            RETVAL = (ctx != NULL) ? 1 : 0;
            if (ctx) {
                ggml_free(ctx);
            }
        OUTPUT:
            RETVAL

=head2 Using Alien::GGML with FFI::Platypus

When C<ggml> is installed as a shared library (for example via a system package
with C<pkg-config>), L<FFI::Platypus> can bind to it at runtime using
C<dynamic_libs>:

    use strict;
    use warnings;
    use FFI::Platypus 2.00;
    use Alien::GGML;

    my @libs = Alien::GGML->dynamic_libs;
    die 'No shared libraries found (share installs build static archives)'
        unless @libs;

    my $ffi = FFI::Platypus->new(
        api => 2,
        lib => \@libs,
    );

    # Attach C functions exported by libggml, e.g. ggml_time_ms:
    $ffi->attach(ggml_time_ms => [] => 'sint64');
    print 'ggml_time_ms: ', ggml_time_ms(), "\n";

Note that a C<share> install builds static archives (C<-DBUILD_SHARED_LIBS=OFF>)
for reliable XS linking, so C<dynamic_libs> is typically populated only for a
C<system> install that provides shared libraries.

=head2 Controlling System vs. Share Installation

L<Alien::Build> honours the C<ALIEN_INSTALL_TYPE> environment variable across
Linux, macOS, and Windows:

=over 4

=item * B<Force a system install> (fail if C<pkg-config> cannot find C<ggml>):

    # Linux / macOS
    ALIEN_INSTALL_TYPE=system cpanm Alien::GGML

    # Windows (PowerShell)
    $env:ALIEN_INSTALL_TYPE = 'system'; cpanm Alien::GGML

=item * B<Force a share install> (always download and build C<ggml> from source via CMake):

    # Linux / macOS
    ALIEN_INSTALL_TYPE=share cpanm Alien::GGML

    # Windows (PowerShell)
    $env:ALIEN_INSTALL_TYPE = 'share'; cpanm Alien::GGML

=back

If C<ALIEN_INSTALL_TYPE> is unset, C<Alien::GGML> probes C<pkg-config> for
C<ggml> first and falls back to building from source if not found.

=head2 Inspecting the Installation

See F<examples/check_alien.pl> in this distribution for a runnable script that
prints C<install_type>, C<version>, C<cflags>, C<libs>, and C<dynamic_libs>.

=head1 AUTHOR

C.J. Collier E<lt>cjac@google.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2026 Google LLC

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
