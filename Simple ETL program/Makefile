# CSE30 Makefile
# 
# EXE - objects we want to build
# OBJS - ojects we want to compile (from c)
# 
# We provide a phony target clean to rm all the .o files
# 
# Run make to run with warnings
# Run make no_warnings to run without warnings
# Run make clean to clean objects

EXE = cnvtr
OBJS = converter.o
.PHONY: clean

$(EXE) : $(OBJS)
	gcc -Wall -Wextra -o $@ $(OBJS)

no_warnings : $(OBJS)
	gcc -o $(EXE) $(OBJS)

converter.o : converter.c
	cc -g -c -o $(OBJS) converter.c

clean :
	rm $(EXE)
	rm -f $(OBJS)