#!/usr/bin/perl6

use v6;

# the first test :)

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
while $item = $next( ) {
    sleep 0.5;
    ok $item;
    say $item;
}

# end of test