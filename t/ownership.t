#!/usr/bin/env perl6

use v6;
use lib 'lib';
use Test;
use Coro::Simple;

# thread ownership test

plan 1;

my $coro = coro {
  suspend;
  yield(1 + 1);
};

my $gen = $coro( );

await start {
  throws-like { $gen() }, "Yield called outside the owner coroutine!";
};
