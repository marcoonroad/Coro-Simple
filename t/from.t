#!/usr/bin/env perl6

use v6;
use lib 'lib';
# "casts" a generator to lazy array

use Test;
use Coro::Simple;

plan 4;

my $expected = slurp './t/expected/from.out';
my $handler = open './t/expected/from.out', :w;

my &iter = coro sub (*@xs) {
  for @xs -> $x {
    $handler.say: "Yay! You get $x.";
    yield $x;
  }
}

my $next = iter 3 ... -2;

my @array := (from $next).map(* + 1).list; # bind the lazy array returned

is @array[ 0 ], 4, "1st generator element must be 4";
is @array[ 1 ], 3, "2nd generator element must be 3";
is @array[ 2 ], 2, "3rd generator element must be 2";

$handler.close;
my $current = slurp './t/expected/from.out';
is $expected, $current, "generated logs must match";

# end of test
