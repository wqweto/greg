# greg

greg used to be _why's fork of Ian Piumarta's peg/leg, with the following differences:

  * Re-entrant
  * Some bug fixes

Since then, better error handling and other various features have been added.

## Links

  * [Ian Piumarta's peg/leg](http://piumarta.com/software/peg/)
  * [2004 PEG paper](http://pdos.csail.mit.edu/papers/parsing%3Apopl04.pdf)

The most comprehensive example of greg usage is in [nagaqueen][nagaqueen],
an ooc grammar, used in [rock][rock], an [ooc][ooc] compiler written in ooc.

[nagaqueen]: http://github.com/nddrylliog/nagaqueen
[rock]: http://github.com/nddrylliog/rock
[ooc]: http://ooc-lang.org

## Build instructions

With a GCC-like compiler, `make` should give you a greg executable.

If you modify `greg.g` (greg's own grammar is written in LEG), run `make grammar` to
regenerate `greg.c` using greg itself, then run `make` again to build it.

## Contributor guidelines

  * [GitHub pull requests](https://github.com/nddrylliog/greg/pulls) are the preferred way to submit contributions.
  * Don't modify `greg.c`, instead, modify `greg.g` and regenerate it as shown above.
  * Make sure greg is still self-hosting before you submit your code.
  * Major changes warrant a version bump, but they also warrant discussions.

For a list of contributors, see the [GitHub contributor graph](https://github.com/nddrylliog/greg/graphs/contributors).

## License

peg/leg is copyright (c) 2007 by Ian Piumarta released under an MIT license. As is greg.
