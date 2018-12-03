#!/usr/bin/env perl6

use v6;
use lib 'lib';
# a transfer function test

use Test;
use Coro::Simple;

plan 2;

my $expected = slurp './t/expected/transfer.out';
my $handler = open './t/expected/transfer.out', :w;

sub transfer (&generator) {
  yield &generator;
}

# impure 'begin' function
# sub begin (&generator) {
#    my $transferred = generator;
#    $transferred = $transferred( ) while $transferred;
# }

# pure 'begin' function
multi begin (Bool $) { }
multi begin (&generator) { begin generator( ) }

my $first;
my $second;
my $third;

my &ping = coro -> $msg {
  for ^3 -> $i {
    $handler.say: "$msg -> $i";
    transfer $second;
  }
}

my &wtf = coro {
  for ^3 {
    $handler.say: "\n" ~ "WTF?" ~ "\n\n";
    transfer $third;
  }
}

my &pong = coro -> $msg {
  for ^3 -> $i {
    $handler.say: "$msg -> $i";
    transfer $first;
  }
}

$first  = ping "Ping!";
$second = wtf;
$third  = pong "Pong!";

ok $first && $second && $third, "we have valid generators at hand";

begin $first; # begin the cycle with this generator

# a small / useful scheduler-like chunk
# (from $ping).map(&from).map: { &^generator( ) };

# for from $ping -> $coro {
#     for from $coro -> $next {
# 	$next( );
#     }
# }

$handler.close;
my $current = slurp './t/expected/transfer.out';
is $current, $expected, "generated logs must match";

# end of test
