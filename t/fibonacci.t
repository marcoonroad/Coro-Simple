#!/usr/bin/perl6

use v6;

# a test that yields values from a stream

use Test;
use Coro::Simple;

plan 5;

# lazy fibonacci sequence generator
my &fibonacci = coro {
    my @xs := (^2, * + * ... *).list;
    yield $_ for @xs;
};

my $get = fibonacci;

# will generate the first 5 numbers from fibonacci sequence
ok $get( ) == 0;
ok $get( ) for ^4;

# end of test
