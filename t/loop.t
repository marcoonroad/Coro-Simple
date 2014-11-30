#!/usr/bin/perl6

use v6;

# a test just for a loop

use Test;
use Coro::Simple;

plan 4;

# loop example
my &xtimes = coro -> &blk, $range {
    for @$range -> $i { blk($i) }
}

# generator function
my $loop = (xtimes -> $x {
    "Hello, World! (n' $x)...".say;
    yield; # default yield: True
}, [ 1 ... 3 ]);

ok $loop( );

sleep 0.5;
ok $loop( );

sleep 0.5;
ok $loop( );

sleep 0.5;
ok not $loop( ); # here, the coroutine is dead

# end of test