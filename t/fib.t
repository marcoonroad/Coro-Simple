#!/usr/bin/perl6

use v6;

use Test;
use Coro::Simple;

plan 15;

# iterator example
my &iter = coro -> @array {
    for @array -> $x { yield $x }
}

# generator function
my $next = iter ^2, *+* ... *;

# will generates the first 15
# numbers from fibonacci sequence
my $item = $next( );

# (per 1 sec of delay, each)
for ^15 {
    sleep say $item;
    ok $item = $next( );
}

# end of test