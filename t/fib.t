#!/usr/bin/perl6

use v6;

# a test that yields values from streams

use Test;
use Coro::Simple;

plan 15;

# iterator example
my &iter = coro -> @array {
    for @array -> $x { yield $x }
}

# generator function
my $next = iter ^2, *+* ... *; # lazy fibonacci sequence

# will generates the first 15
# numbers from fibonacci sequence
my $item;

# (per 1/2 sec of delay, each)
for ^15 {
    $item = $next( );
    ok defined $item;
    say $item;
    sleep 0.5;
}

# end of test