#!/usr/bin/perl6

use v6;

module Coro::Simple;

# receives a simple block or pointy block
sub coro (&block) is export {
    # returns a lambda as constructor
    return sub (*@args) {
	my @yields := gather block |@args; # flat the params
	# that will returns the generator
	return {
	    state $index = 0; # array "pointer"
	    my $result;
	    if defined @yields[ $index++ ] { # increase 'index' "pointer" to next after
		$result = @yields[ $index - 1 ];
	    }
	    else {
		$result = False; # I just don't like null :P
	    }
	    $result;
	}
    }
}

# only can yield only one value per cycle...
sub yield ($value?) is export {
    if defined $value {
	take $value;
    }
    else {
	take True;
    }
}

# to check if generated value was a yielded one
sub assert (&blk, $value) is export {
    # is false?
    if ($value ~~ Bool) && (!$value) {
	return blk( );
    }
    return $value; # else
}

# receives a generator and returns a lazy list
sub from (&gen) is export {
    my $temp = gen;
    my @lazy := gather {
	# return more a value until it becomes False
	while ($temp !~~ Bool) || (?$temp) {
	    take $temp;
	    $temp = gen;
	}
    }
    return @lazy; # you must bind it to an array when calling the 'from' function
}

# end of module