#!/usr/bin/perl6

use v6;

# a test that yields values from a stream

use Test;
use Coro::Simple;

plan 5;

# lazy fibonacci sequence generator
my &fibonacci = coro {
    my @xs := ^2, * + * ... *;
    yield $_ for @xs;
};

my $get = fibonacci;

my $result;

# will generate the first 5
# numbers from fibonacci sequence
for ^5 {
    ok $get( );
}

# end of test