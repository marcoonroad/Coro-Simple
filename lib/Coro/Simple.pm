#!/usr/bin/perl6

use v6;

module Coro::Simple {
    # receives an arrow block
    sub coro (&block) is export {
	# returns a closure as constructor
	return sub (*@args) {
	    my @yields := gather block @args.flat;
	    my $index   = 0;
	    # so, will returns the generator
	    return -> { @yields[ $index++ ] };
	}
    }

    # yields multiple values, called inside an arrow block
    sub yield (*@args) is export {
	if @args {
	    take @args.list;
	}
	else {
	    take True;
	}
    }
}

# end of module