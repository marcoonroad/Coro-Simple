#!/usr/bin/perl6

use v6;

module Coro::Simple;

# receives a simple block / pointy block
sub coro (&block) is export {
    # returns a closure as constructor
    return sub (*@params) {
        my @yields := gather block |@params; # flat the arguments
        my $index   = 0; # array "pointer"
        # that will returns the generator
        return sub ( ) {
            my $result;
            # increase 'index' "pointer" to next, after
            if defined @yields[ $index++ ] {
                $result = @yields[ $index - 1 ];
            }
            else {
                $result = False; # I just don't like null :P
            }
            return $result;
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

# to check if generated value was a yielded one (instead just False)
sub assert (&block, $value) is export {
    # is False?
    if ($value ~~ Bool) && (!$value) {
	return block;
    }
    return $value; # else
}

# receives a generator and returns a lazy list
sub from (&generator) is export {
    my $temp = generator;
    # eval-by-need trick
    my @lazy := gather {
        # request more a value until it becomes False
        while ($temp !~~ Bool) || (?$temp) {
            take $temp;
            $temp = generator;
        }
    }
    # you can bind it to an array when calling the 'from' function
    return @lazy;
}

# end of module