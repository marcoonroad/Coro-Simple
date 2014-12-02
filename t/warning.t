#!/usr/bin/perl6

use v6;

# warning test using 'assert'

use Test;
use Coro::Simple;

plan 4;

# iterator example
my &iter = coro sub (*@xs) { @xs.map: &yield }

# generator function
my $next = iter 1, 2, 3;

ok (assert { warn "Sorry, but the coroutine is dead..." }, $next( )).say;
ok (assert { warn "Sorry, but the coroutine is dead..." }, $next( )).say;
ok (assert { warn "Sorry, but the coroutine is dead..." }, $next( )).say;
ok (assert { warn "Sorry, but the coroutine is dead..." }, $next( )).say;

# end of test
