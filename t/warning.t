#!/usr/bin/perl6

use v6;

# warning test using 'assert'

use Test;
use Coro::Simple;

plan 5;

my &iter = coro sub (*@xs) { yield $_ for @xs };

my $next = iter (1, 2, 3);

my @evals = ();

is((ensure { @evals.push('A'); 7 }, $next( )), 1, "1st must be 1");
is((ensure { @evals.push('B'); 7 }, $next( )), 2, "2nd must be 2");
is((ensure { @evals.push('C'); 7 }, $next( )), 3, "3rd must be 3");
is((ensure { @evals.push('D'); 7 }, $next( )), 7, "4th must be 7");

ok((@evals ~~ @('D')), "must only evaluates the last generator handler");

# end of test
