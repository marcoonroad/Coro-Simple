#!/usr/bin/perl6

use v6;

# a test that yields multiple values

use Test;
use Coro::Simple;

plan 9;

# map example
my &transform = coro sub (*@array) {
    my &function = @array.pop;
    for @array -> $x, $y, $z {
	function $x;
	function $y;
	function $z;
    }
}

# constructor use
my &get-next = transform 45 ... 15, -> $x {
    yield [ $x, $x + 1, $x ** 2 ] # will yields an anonymous list
};

my $items;

# iterating with delays of 1/2 second
for ^9 {
    $items = get-next;
    ok defined $items;
    say $items;
    sleep 0.5;
}

# end of test