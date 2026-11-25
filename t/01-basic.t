use strict;
use warnings;
use Test::More;
use Test::Alien;
use Alien::GGML;

alien_ok 'Alien::GGML';

my $xs = <<'END_XS';
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <ggml.h>

MODULE = TA_MODULE PACKAGE = TA_MODULE

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
END_XS

xs_ok $xs, with_subtest {
    my ($module) = @_;
    ok($module->check_ggml_init(), 'ggml_init / ggml_free succeeded');
};

done_testing();
