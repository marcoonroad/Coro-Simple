#!/usr/bin/env perl6

use v6;
use lib 'lib';
# a range generator test

use Test;
use Coro::Simple;

plan 6;

my $expected = slurp './t/expected/xrange.out';
my $handler = open './t/expected/xrange.out', :w;

my &xrange = coro -> $min, $max, $step {
  for $min, $min + $step ...^ $max -> $num {
    yield $num;
  }
}

my $next = xrange (20, 30, 2);

# first result
my $value = $next( );

# loop until $item becomes False
while $value {
  ok((defined $value), "generator result is non-null");
  $handler.say: "$value";
  $value = $next( );
}

$handler.close;
my $current = slurp './t/expected/xrange.out';
is $expected, $current, "generated logs must match";

# end of test
