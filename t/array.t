#!/usr/bin/perl6

use v6;

# a test yielding an anonymous array

use Test;
use Coro::Simple;

plan 3;

# coroutine wrapper example
my $wrap = coro -> @args {
    for @args[ 0 ].list -> $x { @args[1]($x) }
}

# constructor use
my $next = $wrap([ 3 ... 1 ], -> $n { yield [ $n, $n + 1 ] });

my $item;

# iterating with delays of 1/2 second
sleep +(ok say $next( )) / 2 for ^3;


# end of test