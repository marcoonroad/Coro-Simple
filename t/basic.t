#!/usr/bin/perl6

use v6;

use Test;
use Coro::Simple;

plan 6;

my $expected = slurp './t/expected/basic.out';
my $handler = open './t/expected/basic.out', :w;

my $coro = coro {
  my $cnt = 1;
  $handler.say: "cnt has: $cnt";
  yield $cnt;

  $cnt += 1;
  $handler.say: "cnt (again) has: $cnt";
  yield [ $cnt, $cnt ];

  $cnt = "Now I'm a string!";
  $handler.say: "Now, cnt is a string? { $cnt ~~ Str }";
  yield $cnt;

  $handler.say: "Hi, folks!";
  $handler.say: "Hello ", "World!" ;
  suspend;

  $handler.say: "See ya later";
  yield [ "Bye-bye!".comb ];
};

my $gen    = $coro( );
my $result = $gen( );

while ($result !~~ Bool) || (?$result) {
  ok((defined $result), "generator result is non-null");
  $result = $gen( );
}

$handler.close;
my $current = slurp './t/expected/basic.out';
is $expected, $current, "generated logs must match";

# end of test
