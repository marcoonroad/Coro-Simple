#!/usr/bin/perl6

use v6;

# a test just for a loop

use Test;
use Coro::Simple;

plan 5;

my $expected = slurp './t/expected/loop.out';
my $handler = open './t/expected/loop.out', :w;

my &xtimes = coro -> &block, $init, $final, $step {
  for $init, $init + $step ... $final -> $i {
    block($i);
  }
}

my $loop = (xtimes -> $x {
  $handler.say: "Hello, World! -> { $x }";
  suspend;
}, 1, 3, 1);

for ^3 {
  ok $loop( ), "generator result is non-null";
}

nok $loop( ), "coroutine generator must be dead"; # dead

$handler.close;
my $current = slurp './t/expected/loop.out';
is $current, $expected, "generated logs must match";

# end of test
