#!/usr/bin/perl6

use v6;

# the first test :)

use Test;
use Coro::Simple;

plan 6;

# iterator example
my &iter = coro { @$^xs.map: &yield }

# generator function
my $next = iter [ 3 ... -2 ];

# generates a value
my $item = $next( );

# loop until $item becomes a Bool
# value, delaying 0.5 second by cycle
while $item !~~ Bool {
    ok defined $item;
    say $item;
    $item = $next( );
    sleep 0.5;
}

# end of test