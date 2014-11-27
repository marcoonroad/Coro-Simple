Coro-Simple
===========

Simple coroutines for Perl 6, inspired on Lua's *coroutine.wrap* / *coroutine.yield* functions.

This is a module for asymmetric coroutines, a.k.a coroutines that suspend their flows
with *yield*, but not (instead) change the control flow to another coroutine with *transfer* (these
are symmetric ones).

### Features and Issues ###

The *coro* / *yield* functions from this module are implemented using *gather* / *take*.
The *gather* / *take* have some interesting features:

* Dynamic Scope based: it don't care about how many calls down are to find a *take*.
* Lists Generator: useful for list comprehension.
* Lazy: delay the evaluation until you really need it.

Based on this, the *coro* / *yield* also have some features:

* The coroutine don't care about how many calls down are to find a *yield*.
* Only generates one value per cycle, but you can yield an anonymous array to avoid it.
* You can pass a stream to a coroutine as argument.


But, there are some issues, too:

* I advise you to not use *gather* / *take* inside a coroutine, even I don't know what will happen.
* Don't generates the last values with *return*.

You can yield, too, nothing (just for a temporary exchange of control flow). Don't worry about,
it will takes (internally) the True value.

### Examples ###

##### Coroutine: Declaration #####

So, let's go see some examples.

First, you declares a coroutine with:

```perl6
coro { ... }; # zero-arity coroutine
```

Or with:

```perl6
coro -> $param1, $param2, $param3 { ... }; # 3-arity coroutine
```

Or even with:

```perl6
coro -> @params { ... }; # variadic arguments
```


##### Coroutine: Constructor #####

Later, the *coro* keyword return a constructor, but why it returns a constructor?
Well, for two reasons:

* Code reuse: you can use the coroutine on different places, without declare again it every time.
* Reset / Restore to initial state: when the coroutine dies, you can just assign it again to the generator.

Some example (Python-like iter function):

```perl6
my &iter = coro -> @xs {
    for @xs -> $x {
        yield $x;
    }
}
```

The *iter* function above will receives a flattened array and returns a generator function. Well remembered,
now we will see generators.

##### Coroutine: Generator #####

Note: here, the generator definition is just for a function that returns the next value (every time that it is called).
Not a "stackless" assymetric coroutine (that cares about if will call *yield* out of their block / lexical scope),
a.k.a lexical scope based coroutines.

Keeping the *iter* example:

```perl6
my $generator = iter 1, 2, 3;

say $generator( ); # >>> 1
say $generator( ); # >>> 2
say $generator( ); # >>> 3
say $generator( ); # >>> False, here, the coroutine is dead.
# Use "$generator = iter 1, 2, 3;" again if you want...
```

##### Coroutine: More complex examples #####

Yep, you can build a *map* / *grep* like coroutines!

```perl6
# map coroutine
my &transform = coro -> @xs {
    my &fn = @xs.pop; # the function is included in the last position of the array
    for @xs -> $x {
        yield fn($x);
    }
}

# grep coroutine
my &filter = coro -> @xs {
    my &pred = @xs.pop;
    for @xs -> $x {
        yield $x if pred($x);
    }
}

# Usage:
#
# sub incr ($x) { $x + 1 }      # >>> number.
# sub even ($x) { $x % 2 == 0 } # >>> boolean. use "$x %% 2" if you wish...
#
# my $generator = transform @array.list, &incr;
# my $filtered  = filter @array.list, &even;
#
# :)
```

Happy Hacking! :)

Pull requests are welcome.

TODO
====

* Insert more examples here (show the code).
* Document the module with Perl 6's Pods.

End.