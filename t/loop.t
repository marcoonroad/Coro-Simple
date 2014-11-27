#!/usr/bin/perl6

use v6;

# a test just for a loop

use Test;
use Coro::Simple;

plan 4;

# loop example
my $times = coro -> $max {
    for 1 ... $max {
	"Hello, World!" ==> say;
	yield;
    }
}

# generator function
my $loop = $times(3);

ok $loop( );

sleep 0.5;
ok $loop( );

sleep 0.5;
ok $loop( );

sleep 0.5;
ok not $loop( ); # here, the coroutine is dead

# end of test