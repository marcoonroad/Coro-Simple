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
# loop until $item becomes Nil
sleep say $item while $item = $next( );

# Note: some bug doesn't let you yields the number 0...

# end of test