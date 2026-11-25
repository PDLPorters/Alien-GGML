#!/usr/bin/env perl
# Copyright 2026 Google LLC

use strict;
use warnings;
require Alien::GGML;

my $install_type = Alien::GGML->install_type // 'unknown';
my $version      = Alien::GGML->version      // 'unknown';
my $cflags       = Alien::GGML->cflags       // '';
my $libs         = Alien::GGML->libs         // '';
my @dynamic_libs = Alien::GGML->dynamic_libs;

print 'Alien::GGML installation details:', "\n";
print '  install_type : ', $install_type, "\n";
print '  version      : ', $version,      "\n";
print '  cflags       : ', $cflags,       "\n";
print '  libs         : ', $libs,         "\n";
print '  dynamic_libs : ', (@dynamic_libs ? join(', ', @dynamic_libs) : '(none)'), "\n";
