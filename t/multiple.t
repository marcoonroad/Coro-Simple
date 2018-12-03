#!/usr/bin/env perl6

use v6;
use lib 'lib';
# a test that yields multiple values

use Test;
use Coro::Simple;

plan 8;

my $expected = slurp './t/expected/multiple.out';
my $handler = open './t/expected/multiple.out', :w;

my &transform = coro sub (&fn, *@xs) {
  for @xs -> $x, $y, $z {
    fn $x;
    fn $y;
    fn $z;
  }
}

my &get-next = transform -> $x {
  yield [ $x, $x + 1, $x ** 2 ] # will yields an anonymous list
}, (45 ... 15);

my $items;

for ^7 {
  $items = get-next;
  ok((defined $items), "generator result is non-null");
  $handler.say: "$items";
}

$handler.close;
my $current = slurp './t/expected/multiple.out';
is $expected, $current, "generated logs must match";

# end of test
