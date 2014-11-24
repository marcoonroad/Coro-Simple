#!/usr/bin/perl6

use v6;
use Coro::Simple;

# looping example
my $times = coro -> $max {
    for 1 ... $max {
	"Hello, World!".say;
	yield;
    }
}

# generator function
my $loop = $times(3);

$loop( );

sleep 1;
$loop( );

sleep 1;
$loop( );

sleep 1;
$loop( ); # here, the coroutine is dead

# end of test