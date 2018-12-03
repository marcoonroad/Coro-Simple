all: test

install:
	zef --force install .

test:
	PERL6LIB=lib/ prove -r --color --timer --shuffle --exec=perl6 t/
