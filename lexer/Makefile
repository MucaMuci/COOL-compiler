# flagovi za kompajliranje i linkanje
# -g je za debug
# -Wall pali sva upozorenja
# -Wno-unused da ne upozorava ako se ne koristi return value
# -Wno-write-strings miče upozorenje za konverziju string konst u char*
# -I dodaje putanju do headera


CFLAGS= -g -Wall -Wno-unused -Wno-deprecated -Wno-write-strings -DDEBUG -I.

.PHONY: lexer
.PHONY: lexer_test

lexer:	
# prvo sa flexom radi lexer datoteke
	flex -d -ocool-lex.cc cool.flex 
# onda kompajlira pomocne datoteke bez linkanja
# -c samo kompajlira, ne linka
	g++ ${CFLAGS} -c cool-lex.cc
	g++ ${CFLAGS} -c handle_flags.cc
	g++ ${CFLAGS} -c stringtab.cc
	g++ ${CFLAGS} -c utilities.cc
	g++ ${CFLAGS} -c lextest.cc
# na kraju linka sve kompajlirane datoteke skupa
# -lfl je uključivanje biblioteke libfl.a od flexa
# -o je ime izlazne datoteke
	g++ ${CFLAGS} lextest.o utilities.o stringtab.o handle_flags.o cool-lex.o -o lexer
	
lexer_test:
	g++ lexer_test.cpp -o lexer_test
