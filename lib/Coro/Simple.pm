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
	    return -> {
		my $result;
		if defined @yields[ $index++ ] {
		    $result = @yields[ $index - 1 ];
		}
		else {
		    $result = False; # I just don't like null :P
		}
		$result;
	    };
	}
    }

    # can yields multiple values, e.g. but they need to
    # be an array or hash. called inside an arrow block
    sub yield ($value?) is export {
	if defined $value {
	    take $value;
	}
	else {
	    take True;
	}
    }
}

# end of module