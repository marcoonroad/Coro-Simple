Coro-Simple
===========

Simple coroutines for Perl 6, inspired on Lua's *coroutine.wrap* / *coroutine.yield* functions.

This is a module for asymmetric coroutines, a.k.a coroutines that suspend their flows
with *yield*, but not (instead) change the control flow to another coroutine with *transfer* (these
are symmetric ones).


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


TODO:
* Insert examples here (show the code).
* Document the module with Perl 6's Pods.