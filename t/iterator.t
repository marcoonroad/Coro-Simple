#!/usr/bin/perl6

use v6;

# array traversal  test

use Test;
use Coro::Simple;

plan 4;

my $expected = slurp './t/expected/iterator.out';
my $handler = open './t/expected/iterator.out', :w;

my &iter = coro sub (*@xs) {
  for @xs -> $x {
	  $handler.say: "Yielding $x...\n";
    yield $x;
  }
};

for from iter 1 ... 3 -> $x {
  ok $x, "generator result is non-null";
}

$handler.close;
my $current = slurp './t/expected/iterator.out';
is $expected, $current, "generated logs must match";

# end of test
