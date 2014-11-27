#!/usr/bin/perl6

use v6;

# a test that yields values from a stream

use Test;
use Coro::Simple;

plan 15;

# lazy iterator example
my &each = coro -> @xs {
    for @xs -> $x { yield $x }
}

# generator function
my &get = each 0, 1, * + * ... *; # lazy fibonacci sequence

my $result;

# will generates the first 15
# numbers from fibonacci sequence
# (per 1/2 sec of delay, each)
for ^15 {
    $result = get;
    ok defined $result;
    say $result;
    sleep 0.5;
}

# end of test