# flagovi za kompajliranje i linkanje
# -g je za debug
# -Wall pali sva upozorenja
# -Wno-unused da ne upozorava ako se ne koristi return value
# -Wno-write-strings miče upozorenje za konverziju string konst u char*
# -I dodaje putanju do headera


CFLAGS= -g -Wall -Wno-unused -Wno-deprecated -Wno-write-strings -DDEBUG -I.

.PHONY: parser
.PHONY: parser_test

parser:	
# prvo sa bisonom radi bison datoteke
	bison -d -v -y -b cool --debug -p cool_yy cool.y 
# preimenujem
	mv -f cool.tab.c cool-parse.cc
# onda kompajlira pomocne datoteke bez linkanja
# -c samo kompajlira, ne linka
	g++ ${CFLAGS} -c parser-phase.cc
	g++ ${CFLAGS} -c utilities.cc
	g++ ${CFLAGS} -c stringtab.cc
	g++ ${CFLAGS} -c dumptype.cc
	g++ ${CFLAGS} -c tree.cc
	g++ ${CFLAGS} -c cool-tree.cc
	g++ ${CFLAGS} -c tokens-lex.cc
	g++ ${CFLAGS} -c handle_flags.cc
	g++ ${CFLAGS} -c cool-parse.cc
# na kraju linka sve kompajlirane datoteke skupa
# -lfl je uključivanje biblioteke libfl.a od flexa
# -o je ime izlazne datoteke
	g++ ${CFLAGS} parser-phase.o utilities.o stringtab.o dumptype.o tree.o cool-tree.o tokens-lex.o handle_flags.o cool-parse.o -lfl -o parser
	
parser_test:
	g++ parser_test.cpp -o parser_test
