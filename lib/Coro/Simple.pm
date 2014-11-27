#!/usr/bin/perl6

use v6;

module Coro::Simple;

# receives a simple block or pointy block
sub coro (&block) is export {
    # returns a lambda as constructor
    return sub (*@args) {
	my @yields := gather block @args.flat;
	my $index   = 0;
	# that will returns the generator
	return {
	    my $result;
	    if defined @yields[ $index++ ] {
		$result = @yields[ $index - 1 ];
	    }
	    else {
		$result = False; # I just don't like null :P
	    }
	    $result;
	}
    }
}

# only can yield one value per cycle...
sub yield ($value?) is export {
    if defined $value {
        take $value;
    }
    else {
	take True;
    }
}

# end of module