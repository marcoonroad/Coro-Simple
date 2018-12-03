use v6;

unit module Coro::Simple;

sub coro (&block) is export {
  my $coroutine-thread = $*THREAD;

  return sub (*@params) {
    # we explore the lazy evaluation property
    # to evaluate the computation on demand
    my @yields := (gather { block |@params }).list;
    my $index   = 0;
    # generator
    return sub ( ) {
      unless $*THREAD.id == $coroutine-thread.id {
        die "Yield called outside the owner coroutine!";
      }

      my $result;
      if defined @yields[ $index++ ] {
        $result = @yields[ $index - 1 ];
      }
      # otherwise, if the coroutine is dead
      else {
	      $index -= 1; # disallows further lookups
        $result = False;
      }
      return $result;
    }
  }
}

sub yield ($value) is export { take $value }

sub suspend( ) is export { take True }

# purpose:
# to check if generated value was returned from yield triggering (rather end of computation)
sub ensure (&block, $value) is export {
  if ($value ~~ Bool) && (!$value) {
    return block;
  }
  return $value;
}

sub from (&generator) is export {
  my $temp = generator; # obtains the first value

  return gather {
    while ($temp !~~ Bool) || (?$temp) {
      take $temp;
      $temp = generator;
    }
  };
}

# end of module
