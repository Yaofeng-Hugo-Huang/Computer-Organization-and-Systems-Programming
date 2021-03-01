#
# CSE30 Makefile
#
# we declare the object we want to build in the variable EXE
# we list the objects we want to compile (from c) in OBJS
#
# we provide a phony target clean to rm all the .o files
#

EXE = convertfp
OBJS = main.o fp2float.o
LIBS = 
CC = gcc 
CFLAGS = -g -O0 -Wall
CFLAGS += --std=gnu99

.PHONY: clean

$(EXE) : $(OBJS)
	gcc -o $@ $(CFLAGS) $(OBJS) $(LIBS)

main.o : main.c
fp2float.o : fp2float.s
	gcc -c $(CFLAGS) -gstabs+ fp2float.s

makebin: makebin.c
	gcc -o makebin $(CFLAGS) makebin.c

clean :
	rm -f $(EXE) $(OBJS) makebin
