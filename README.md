Coro-Simple
===========

Simple coroutines for Perl 6, inspired on Lua's *coroutine.wrap* / *coroutine.yield* functions.

This is a module for **(full) asymmetric coroutines**, coroutines that suspend their flows
with *yield* instead change the control flow to another coroutine with *transfer* (these
are called **symmetric** ones).

If you want to know more about coroutines, I suggest you to read this nice paper:
http://www.inf.puc-rio.br/~roberto/docs/MCC15-04.pdf ...





### ~> Features and Issues ###

The *coro* / *yield* functions from this module are implemented using the *gather* / *take* built-in
P6's functions. The *gather* / *take* has some interesting features:

* **It has a dynamic scope:** it don't care about how many calls down are to find a *take*.
* **It's a list generator:** useful for list-comprehension-like stuff.
* **It also is lazy:** delay the evaluation until you really need it.


Based on the stuff above, the *coro* / *yield* itself also has some features:

* The coroutine don't care about how many calls down are to find a *yield*, even inside many other nested functions.
* The *yield* only generates one value per cycle, but you can yield an anonymous list to avoid it.
* You can pass a stream to a coroutine as argument (but currently this feature still isn't supported).


But, there are some issues, too:

* I advise you to not use *gather* / *take* inside any coroutine, even I don't know what will happen.
* It don't generates the last values with *return* (as is the case of Lua), so you must use *yield* again.


You can also call *yield* with **nothing** (no one argument, just for a temporary change of control flow). Don't worry about,
it will takes internally the True value.





### ~> Description ###

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
coro -> $params {
    for @$params -> $param {
	...
    }
}
# variadic arguments through a anonymous list
```


##### Coroutine: Constructor #####

After, the *coro* keyword returns a constructor, and you may think **"but why it returns a constructor?"**...
Well, for two mainly reasons:

* **For code reuse:** you can use the coroutine on different places, without declare / return again it every time.
* **Reset to a initial state:** when the coroutine dies, you can just reassign it to the generator.

On Lua, if you want to reuse a coroutine, you need explicitly to return a coroutine that will reuse the given
arguments (closure-like-stuff)...

```lua
function iter (xs)
    return coroutine.wrap (function ( )
	for _, x in ipairs (xs) do
	    coroutine.yield (x)
	end
    end)
end
```

So, I decided implement a different approach...

Some example (a Python-like *iter* function):

```perl6
my &iter = coro -> $xs {
    for @$xs -> $x {
        yield $x;
    }
}
```

The *iter* function above will receives an anonymous array and returns a **generator** function... Well remembered,
now we will see generators.





##### Coroutine: Generator #####

Note: here, the generator definition is just for a function that returns the next value (every time that it's called),
not as is usually called a **asymmetric coroutine of "unseparated stacks"** (that cares about if you will call *yield* out of
their block / lexical scope).

Reusing the *iter* example:

```perl6
my $generator = iter [ 1, 2, 3 ];

say $generator( ); # >>> 1
say $generator( ); # >>> 2
say $generator( ); # >>> 3
say $generator( ); # >>> False, here, the coroutine is dead.
# Use "$generator = iter [ 1, 2, 3 ];" again if you want...
```





##### Coroutine: More complex examples #####

Yep, you can build a *map* / *grep* / *range* like coroutines / generators!

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

You can build more complex things with it too, without evaluate the whole thing at all (because *map* and *grep* are
lazy too :) ...):

```perl6
my @lazy-array-1 := (from some-constructor($arg1, $arg2, ...)).map: * + 1;

my @lazy-array-2 := (from (coro { ... })(...)).grep: * %% 2;
```





##### Coroutine: Verifying #####

There's also a function called *assert* in this module. Its main purpose is to check a value, so:

* If given value isn't False, return it.
* Otherwise, runs given block (other argument).

Let's see a small example below:

```perl6
$some-value = $some-generator( );

($some-value ==> assert { warn "Sorry, but your coroutine is dead." }) ==> say;
# prints $some-value or generates a warning if is false

$some-value = assert ({ $some-generator = some-constructor( ) }, $some-generator( ));
# reassign to the generator if $some-generator returns False or returns a value
```





##### Coroutine: Implementing symmetric coroutines #####

The support to a *transfer* function is still experimental. Check the 't/transfer.t' test if you wish to know more about.






##### Notes: #####

Pull requests are welcome.

**Happy Hacking using this module!** :)





Tips and Tricks
===============

Naturally, you can build a *enumerator / generator* as this:

```perl6
# receives many arguments (e.g flattened array) and yields each one
my &iter = coro sub (*@xs) { @xs ==> map &yield }
```

And some short version (that receives a anonymous list):

```perl6
my &iter = coro { @$^xs.map: &yield }
```






TODO
====

* Insert more examples here (show the code).
* Document the module with **Perl 6's Pods**.
* Fix the module for the *coro* accepts streams (infinite-length lists) as arguments.






End.