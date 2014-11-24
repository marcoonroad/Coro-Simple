#!/usr/bin/perl6

use v6;
use Coro::Simple;

# iterator example
my &iter = coro -> @array {
    for @array -> $x { yield $x }
}

# generator function
my $next = iter 5 ... 1;

my $item;

# loop until $item becomes Nil,
# delaying 1 second by loop
sleep say $item while $item = $next( );

# end of test