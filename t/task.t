#!/usr/bin/perl6

use v6;

# a task test

use Test;
use Coro::Simple;

plan 2;

my $expected = slurp './t/expected/task.out';
my $handler = open './t/expected/task.out', :w;

my @tasks;

sub add-task ($block) {
  my $coro = coro $block;
  @tasks.push: $coro( );
}

sub dispatch-now ( ) {
  while ?@tasks {
    my $task = @tasks.shift;
    @tasks.push: $task if $task( );
  }
  True;
}

# add a task and run getting started with it
sub spawn-task ($block) {
  my $coro = coro $block;
  my $task = $coro( );
  @tasks.push: $task if $task( );
  ok dispatch-now, "dispatcher ran successfully";
}

# tasks
add-task {
  for ^3 -> $i {
    $handler.say: "Ping -> $i";
    suspend;
  }
}

add-task {
  my @entries = @("\n", "WTF?", "\n\n");

  for ^5 {
    $handler.say: ([~] @entries);
    suspend;
  }
}

spawn-task {
  for ^8 -> $i {
    $handler.say: "Pong -> $i";
    suspend;
  }
}

$handler.close;
my $current = slurp './t/expected/task.out';
is $expected, $current, "generated logs must match";

# end of test
