#!/usr/bin/perl6

use v6;

# array traversal  test

use Test;
use Coro::Simple;

plan 6;

# iterator example
my &iter = coro { @$^xs.map: &yield }

my @values := from iter [ 3 ... -2 ];

ok $_.say for @values;


# end of test