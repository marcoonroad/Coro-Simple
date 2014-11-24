#!/usr/bin/perl6

use v6;

use Test;
use Coro::Simple;

plan 5;

# iterator example
my &iter = coro -> @array {
    for @array -> $x { yield $x }
}

# generator function
my $next = iter 5 ... 1;

my $item;

# loop until $item becomes False,
# delaying 1 second by loop
sleep ok say $item while $item = $next( );

# end of test