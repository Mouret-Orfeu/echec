CC = g++

##-marche=native (adapte la compilation de à l'architecture processeur)
##-pipe parallélise la compilation (et l'accelaire)
##-std=gnu++17 compile avec le standard 17 et ajoute les extentions gnu
##-pedantic erreur supplémentaires au cas où pour d'autres OS
##Je marque tt ça surtout pour moi ^^' 

CFLAGS = -march=native -pipe -std=gnu++17 -pedantic -Wextra -Werror

INCLUDE_PATH = ./headers

TARGET       = echecs
FILEXT       = cc

SRCDIR       = sources
OBJDIR       = objets
BINDIR       = .

SOURCES     := $(wildcard $(SRCDIR)/*.$(FILEXT))
INCLUDES    := $(wildcard $(INCLUDE_PATH)/*.h)
OBJECTS     := $(SOURCES:$(SRCDIR)/%.$(FILEXT)=$(OBJDIR)/%.o)

PATH_TO_EXE  = $(BINDIR)/$(TARGET)


all : release 


debug: CFLAGS += -Og -DDEBUG -g -ggdb
debug: $(PATH_TO_EXE)
	@echo "\033[93mRunning in debug mode!\033[0m"

release: CFLAGS += -Ofast
release: $(PATH_TO_EXE)
	@echo "\033[96mRunning in release mode!\033[0m"

run:
ifneq ("$(wildcard $(PATH_TO_EXE))", "")
	./$(PATH_TO_EXE)
else
	@echo "\033[91mNo executable found!\033[0m"
endif

run-release: release
	./$(PATH_TO_EXE)

run-debug: debug
	valgrind --leak-check=full --show-leak-kinds=all --vgdb=full -s ./$(PATH_TO_EXE)

$(PATH_TO_EXE): $(OBJECTS)
	mkdir -p $(BINDIR)
	$(CC) -o $@ $^ $(CFLAGS) $(LDLIBS)
	@echo "\033[92mLinking complete!\033[0m"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.$(FILEXT) $(INCLUDES)
	mkdir -p $(OBJDIR)
	$(CC) -o $@ -c $< $(CFLAGS) -isystem$(INCLUDE_PATH)



clean:
	rm -f $(OBJDIR)/*.o
	rm -f $(OBJDIR)/*.gcda
	rm -f $(OBJDIR)/*.gcno
	rm -f $(PATH_TO_EXE)