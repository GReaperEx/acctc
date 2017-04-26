T_API_SRC := $(wildcard xAPIs/turtle/*.lua)
T_API_DST := $(patsubst xAPIs/turtle/%.lua, turtle/apis/%, $(T_API_SRC))

C_API_SRC := $(wildcard xAPIs/computer/*.lua)
C_API_DST := $(patsubst xAPIs/computer/%.lua, computer/apis/%, $(C_API_SRC))

T_PRG_SRC := $(wildcard xPrograms/turtle/*.lua)
T_PRG_DST := $(patsubst xPrograms/turtle/%.lua, turtle/progs/%, $(T_PRG_SRC))

C_PRG_SRC := $(wildcard xPrograms/computer/*.lua)
C_PRG_DST := $(patsubst xPrograms/computer/%.lua, computer/progs/%, $(C_PRG_SRC))

all : turtle_build computer_build

turtle_build : turtle $(T_API_DST) $(T_PRG_DST)
	@cp xStartups/startup-turtle.lua turtle/startup
	@echo Compiled turtle bundle

turtle :
	@mkdir turtle
	@mkdir turtle/apis turtle/progs

turtle/apis/% : xAPIs/turtle/%.lua
	@cp $< $@

turtle/progs/% : xPrograms/turtle/%.lua
	@cp $< $@

computer_build : computer $(C_API_DST) $(C_PRG_DST)
	@cp xStartups/startup-computer.lua computer/startup
	@echo Compiled computer bundle

computer :
	@mkdir computer
	@mkdir computer/apis computer/progs

computer/apis/% : xAPIs/computer/%.lua
	@cp $< $@

computer/progs/% : xPrograms/computer/%.lua
	@cp $< $@

