#!/usr/bin/perl6

use v6;

use Test;
use Coro::Simple;

plan 4;

# looping example
my $times = coro -> $max {
    for 1 ... $max {
	"Hello, World!".say;
	yield;
    }
}

# generator function
my $loop = $times(3);

ok $loop( );

sleep 1;
ok $loop( );

sleep 1;
ok $loop( );

sleep 1;
ok not $loop( ); # here, the coroutine is dead

# end of test