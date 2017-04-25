SRC := $(shell find . -name *.lua)
OBJ := $(patsubst %.lua, %, $(SRC))

all : $(OBJ)

% : %.lua
	@echo $< "->" $@
	@mv $< $@

