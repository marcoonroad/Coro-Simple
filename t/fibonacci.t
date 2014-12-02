#!/usr/bin/perl6

use v6;

# a test that yields values from a stream

use Test;
use Coro::Simple;

plan 15;

# TODO: fix the 'coro' to accept streams

# lazy iterator example
my &gen-fib = coro {
    (^2, * + * ... *).map: &yield;
}

# generator function
my $get = gen-fib;

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