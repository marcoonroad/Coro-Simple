#!/usr/bin/perl6

use v6;

# the first test :)

use Test;
use Coro::Simple;

plan 7;

# iterator example
my &iter = coro -> @xs {
    for @xs -> $x { yield $x }
}

# generator function
my $next = iter 3 ... -2;

my $item = $next( );
ok defined $item;

# loop until $item becomes a Bool
# value, delaying 0.5 second by cycle
while $item ~~ Int {
    sleep 0.5;
    say $item;
    $item = $next( );
    ok defined $item;
}

# end of test