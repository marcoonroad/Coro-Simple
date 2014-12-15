#!/usr/bin/perl6

use v6;

# a task test

use Test;
use Coro::Simple;

plan 16;

my @tasks; # a queue of tasks

# function to add some task (on last position)
sub add-task ($callable) {
    my &coroutine = coro $callable;
    @tasks.push: coroutine( ); # push a generator
}

# to run the things
sub dispatch-now ( ) {
    while ?@tasks {
	my $task = @tasks.shift;
	@tasks.push: $task if $task( );
    }
}

# tasks
add-task {
    for ^3 -> $i {
	ok say "Ping -> $i";
	sleep 0.5;
	suspend;
    }
}

add-task {
    for ^5 {
	ok say [~] <<\n WTF? \n\n>>;
	sleep 0.5;
	suspend;
    }
}

add-task {
    for ^8 -> $i {
	ok say "Pong -> $i";
	sleep 0.5;
	suspend;
    }
}

dispatch-now( ); # begin to run the tasks

# end of test