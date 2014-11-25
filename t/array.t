#!/usr/bin/perl6

use v6;

# a test yielding an anonymous array

use Test;
use Coro::Simple;

plan 3;

# coroutine wrapper example
my $wrap = coro -> @args {
    for @args[ 0 ].list -> $x {
	@args[ 1 ]($x);
    }
}

# will fills the second parameter
my $fn = sub ($n) { yield [ $n, $n + 1 ] };

# constructor use
my $next = $wrap([ 3 ... 1 ], $fn);

# variable to store generated values
my $item;

# iterating with delays of 1/2 second
for 1 ... 3 {
    $item = $next( );
    ok defined $item;
    say $item;
    sleep 0.5;
}

# end of test