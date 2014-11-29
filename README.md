Coro-Simple
===========

Simple coroutines for Perl 6, inspired on Lua's *coroutine.wrap* / *coroutine.yield* functions.

This is a module for asymmetric coroutines, a.k.a coroutines that suspend their flows
with *yield*, but not (instead) change the control flow to another coroutine with *transfer* (these
are symmetric ones).





### Features and Issues ###

The *coro* / *yield* functions from this module are implemented using *gather* / *take*.
The *gather* / *take* have some interesting features:

* Dynamic-scope based: it don't care about how many calls down are to find a *take*.
* Lists generator: useful for list comprehension.
* Lazy: delay the evaluation until you really need it.


Based on this, the *coro* / *yield* also have some features:

* The coroutine don't care about how many calls down are to find a *yield*, even inside many other functions.
* Only generates one value per cycle, but you can yield an anonymous array to avoid it.
* You can pass a stream to a coroutine as argument (but currently this feature still isn't supported).


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
coro -> $params { for @$params -> $param { ... } }; # variadic arguments
```


##### Coroutine: Constructor #####

Later, the *coro* keyword returns a constructor, but why it returns a constructor?
Well, for two mainly reasons:

* Code reuse: you can use the coroutine on different places, without declare again it every time.
* Reset / Restore to initial state: when the coroutine dies, you can just assign it again to the generator.

Some example (Python-like iter function):

```perl6
my &iter = coro -> $xs {
    for @$xs -> $x {
        yield $x;
    }
}
```

The *iter* function above will receives an anonymous array and returns a generator function. Well remembered,
now we will see generators.





##### Coroutine: Generator #####

Note: here, the generator definition is just for a function that returns the next value (every time that it is called).
Not a "stackless" assymetric coroutine (that cares about if you will call *yield* out of their block / lexical scope),
a.k.a lexical scope based coroutines / semi-coroutines.

Keeping the *iter* example:

```perl6
my $generator = iter [ 1, 2, 3 ];

say $generator( ); # >>> 1
say $generator( ); # >>> 2
say $generator( ); # >>> 3
say $generator( ); # >>> False, here, the coroutine is dead.
# Use "$generator = iter [ 1, 2, 3 ];" again if you want...
```





##### Coroutine: More complex examples #####

Yep, you can build a *map* / *grep* / *range* like coroutines!

```perl6
# map coroutine
my &transform = coro -> &fn, $xs {
    for @$xs -> $x {
        yield fn($x);
    }
}

# grep coroutine
my &filter = coro -> &pred, $xs {
    for @$xs -> $x {
        yield $x if pred($x);
    }
}

# range-like coroutine
my &xrange = coro -> $min, $max {
    for ($min ...^ $max) -> $value {
        yield $value;
    }
}

# Usage:
#
# sub incr ($x) { $x + 1 }      # >>> number.
# sub even ($x) { $x % 2 == 0 } # >>> boolean. use "$x %% 2" if you wish...
#
# my $generator = ([ @array ] ==> transform &incr);
# my $filtered  = ([ @array ] ==> filter &even);
# my $get-next  = xrange ($x, $y);
#
# :)
```





##### Coroutine: "casting" generator to a lazy list #####

If you want to access the values that a generator yields with a nice way, you can use *from*.
The *from* function does the opposite from *iter* function above: instead taking an array and returning a
generator, it takes a reference to a generator and returns a lazy array to bind.

Some examples:

```perl6
my @lazy-array := from $some-generator;
```

Or, too:

```perl6
my @lazy-array := from &some-generator;
```





##### Coroutine: Verifying #####

There's also a function called *assert* in this module. Its main purpose is:

* If given value isn't False, return it.
* Otherwise, if given value is False, runs given block (other argument).

Let's see a small example:

```perl6
$some-value = $some-generator( );
($some-value ==> assert { warn "Sorry, but your coroutine is dead." }) ==> say;
# prints $some-value or generates a warning if is false

$some-value = assert ({ $some-generator = some-constructor( ) }, $some-generator( ));
# reassign to the generator if $some-value is False
```






##### Notes: #####

Happy Hacking! :)

Pull requests are welcome.






Tips and Tricks
===============

Naturally, you can build a iterator / generator as this:

```perl6
# receives many arguments (e.g flattened array) and yields each element
my &iter = coro sub (*@xs) { @xs ==> map &yield }
```

And some short version:
```perl6
my &iter = coro { @$^xs.map: &yield }
```






TODO
====

* Insert more examples here (show the code).
* Document the module with Perl 6's Pods.
* Fix the module to accepts streams (infinite lists).






End.