#!/usr/bin/perl6

use v6;

# the first test :)

use Test;
use Coro::Simple;

plan 5;

# range coroutine
my &xrange = coro -> $min, $max, $step {
    ($min, $min + $step, $min + ($step * 2) ...^ $max).map: &yield;
}

# generator function
my $next = xrange (20, 25, 1);

my $value = $next( );

# loop until $item becomes a Bool
# value, delaying 0.5 second by cycle
while $value ~~ Int {
    ok defined $value;
    say $value;
    $value = $next( );
    sleep 0.5;
}

# end of test