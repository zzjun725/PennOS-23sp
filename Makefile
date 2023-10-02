######################################################################
#
#                       Author: Hannah Pan
#                       Date:   01/13/2021
#
# The autograder will run the following command to build the program:
#
#       make -B
#
# To build a version that does not call kill(2), it will run:
#
#       make -B CPPFLAGS=-DEC_NOKILL
#
######################################################################

# name of the program to build
PROG=penn-os

# prompt of shell
PROMPT='"$(PROG)\# "'

# Remove -DNDEBUG during development if assert(3) is used
# override CPPFLAGS += -DNDEBUG -DPROMPT=$(PROMPT) -DCATCHPHRASE=$(CATCHPHRASE)
override CPPFLAGS += -DNDEBUG -DPROMPT=$(PROMPT) 
# override CPPFLAGS += -DNDEBUG

CC = clang

# Replace -O1 with -g for a debug version during development
#
CFLAGS = -Wall -Werror -O1 -g

# SRCS = $(wildcard src/*.c)
KSRCS = $(filter-out src/kernel/pennos.c, $(wildcard src/kernel/*.c))
FSRCS = $(filter-out src/pennfat/pennfat.c, $(wildcard src/pennfat/*.c))
KOBJS = $(KSRCS:.c=.o)
FOBJS = $(FSRCS:.c=.o)
allobjects:pennos pennfat
.PHONY : allobjects
# SRCS = $(filter-out src/pennfat.c src/pennos.c, $(wildcard src/*.c))
# OBJS = $(SRCS:.c=.o)

# $(allobjects)

pennos: src/kernel/pennos.c $(KOBJS) $(FOBJS)
	$(CC) -o bin/$@ $^ src/kernel/parser.o

pennfat: src/pennfat/pennfat.c $(FOBJS)
	$(CC) -o bin/$@ $^ src/kernel/parser.o

.PHONY : clean

# $(PROG) : $(OBJS)
# 	$(CC) -o bin/$@ $^ src/parser.o

clean :
	$(RM) $(KOBJS) $(FOBJS) bin/$(allobjects)



