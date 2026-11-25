use 5.010;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use Alien::Build::MM;

my $abmm = Alien::Build::MM->new;

WriteMakefile($abmm->mm_args(
    NAME               => 'Alien::GGML',
    DISTNAME           => 'Alien-GGML',
    AUTHOR             => q{C.J. Collier <cjac@google.com>},
    VERSION_FROM       => 'lib/Alien/GGML.pm',
    ABSTRACT_FROM      => 'lib/Alien/GGML.pm',
    LICENSE            => 'perl_5',
    MIN_PERL_VERSION   => '5.010',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '6.52',
        'Alien::Build::MM'    => '0.32',
    },
    BUILD_REQUIRES => {
        'Alien::Build::MM' => '0.32',
        'Alien::cmake3'    => '0.02',
    },
    TEST_REQUIRES => {
        'Test::More'  => '0.88',
        'Test::Alien' => '0',
    },
    PREREQ_PM => {
        'Alien::Base' => '0.038',
    },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources   => {
            repository => {
                type => 'git',
                url  => 'https://github.com/PDLPorters/Alien-GGML.git',
                web  => 'https://github.com/PDLPorters/Alien-GGML',
            },
            bugtracker => {
                web => 'https://github.com/PDLPorters/Alien-GGML/issues',
            },
        },
    },
    clean => { FILES => 'Alien-GGML-* _alien' },
));

sub MY::postamble {
    $abmm->mm_postamble;
}
