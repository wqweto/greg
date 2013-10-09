OFLAGS = -O3 -DNDEBUG -DYY_MAIN
CFLAGS = -g -Wall -Wno-unused-function $(OFLAGS) $(XFLAGS)

SRCS = tree.c compile.c
SAMPLES = $(wildcard samples/*.leg)

all : greg

greg : greg.c $(SRCS)
	$(CC) $(CFLAGS) -o $@-new greg.c $(SRCS)
	cp $@-new $@

ROOT	=
PREFIX	?= /usr
BINDIR	= $(ROOT)$(PREFIX)/bin

install : $(BINDIR)/greg

$(BINDIR)/% : %
	cp -p $< $@
	strip $@

uninstall : .FORCE
	rm -f $(BINDIR)/greg

# bootstrap greg from greg.g
greg.c : greg.g compile.c tree.c
	$(MAKE) greg-new
	./greg-new -o greg-new.c greg.g
	$(CC) $(CFLAGS) -o greg-new greg-new.c $(SRCS)
	cp greg-new.c greg.c
	cp greg-new greg

# bootstrap: call make greg-new when you updated compile.c and greg-new.c
greg-new : greg-new.c $(SRCS)
	$(CC) $(CFLAGS) -o greg-new greg-new.c $(SRCS)

grammar : .FORCE
	./greg -o greg.c greg.g

clean : .FORCE
	rm -rf *~ *.o *.greg.[cd] greg ${SAMPLES:.leg=.o} ${SAMPLES:.leg=} ${SAMPLES:.leg=.c} samples/*.dSYM testing1.c testing2.c *.dSYM selftest/

spotless : clean .FORCE
	rm -f greg

samples/calc.c: samples/calc.leg greg
	./greg -o $@ $<

samples/calc: samples/calc.c
	$(CC) $(CFLAGS) -o $@ $<

samples: ${SAMPLES:.leg=} greg

%.c: %.leg
	./greg $< > $@
.leg.c:
	./greg $< > $@

test: samples run
	echo 'abcbcdabcbcdabcbcdabcbcd' | samples/accept | tee samples/accept.out
	diff samples/accept.out samples/accept.ref
	echo 'abcbcdabcbcdabcbcdabcbcd' | samples/rule | tee samples/rule.out
	diff samples/rule.out samples/rule.ref
	echo '21 * 2 + 0' | samples/calc | grep 42
	echo 'a = 6;  b = 7;  a * b' | samples/calc | grep 42
	echo '  2  *3 *(3+ 4) ' | samples/dc   | grep 42
	echo 'a = 6;  b = 7;  a * b' | samples/dcv  | grep 42
	echo 'print 2 * 21 + 0' | samples/basic | grep 42
	echo 'ab.ac.ad.ae.afg.afh.afg.afh.afi.afj.' | samples/test | tee samples/test.out
	diff samples/test.out samples/test.ref
	cat samples/wc.leg | samples/wc > samples/wc.out
	diff samples/wc.out samples/wc.ref
	echo '6*9' | samples/erract | tee samples/erract.out
	diff samples/erract.out samples/erract.ref

run: greg
	mkdir -p selftest
	./greg -o testing1.c greg.g
	$(CC) $(CFLAGS) -o selftest/testing1 testing1.c $(SRCS)
	$(TOOL) ./selftest/testing1 -o testing2.c greg.g
	$(CC) $(CFLAGS) -o selftest/testing2 testing2.c $(SRCS)
	$(TOOL) ./selftest/testing2 -o selftest/calc.c ./samples/calc.leg
	$(CC) $(CFLAGS) -o selftest/calc selftest/calc.c
	$(TOOL) echo '21 * 2 + 0' | ./selftest/calc | grep 42

.FORCE :
