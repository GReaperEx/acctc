T_API_SRC := $(wildcard xAPIs/turtle/*.lua)
T_API_DST := $(patsubst xAPIs/turtle/%.lua, turtle/apis/%, $(T_API_SRC))

T_PRG_SRC := $(wildcard xPrograms/turtle/*.lua)
T_PRG_DST := $(patsubst xPrograms/turtle/%.lua, turtle/progs/%, $(T_PRG_SRC))

all : turtle_build

turtle_build : turtle $(T_API_DST) $(T_PRG_DST)
	@cp xStartups/startup-turtle.lua turtle/startup
	@echo Compiled turtle bundle

turtle :
	@mkdir turtle
	@mkdir turtle/apis turtle/progs

turtle/apis/% : xAPIs/turtle/%.lua
	@cp $< $@

