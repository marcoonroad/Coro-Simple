#!/usr/bin/perl6

use v6;

# a test that yields values from a stream

use Test;
use Coro::Simple;

plan 15;

# TODO: fix the 'coro' to accept streams

# lazy iterator example
my &fib-gen = coro {
    (^2, * + * ... *).map: &yield; # lazy fibonacci sequence
}

# generator function
my $get = fib-gen;

my $result;

# will generates the first 15
# numbers from fibonacci sequence
# (per 1/2 sec of delay, each)
for ^15 {
    $result = $get( );
    ok defined $result;
    say $result;
    sleep 0.5;
}

# end of test