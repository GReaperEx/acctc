T_API_SRC := $(wildcard apis/turtle/*.lua)
T_API_DST := $(patsubst apis/turtle/%.lua, turtle/apis/%, $(T_API_SRC))

C_API_SRC := $(wildcard apis/computer/*.lua)
C_API_DST := $(patsubst apis/computer/%.lua, computer/apis/%, $(C_API_SRC))

T_PRG_SRC := $(wildcard programs/turtle/*.lua)
T_PRG_DST := $(patsubst programs/turtle/%.lua, turtle/progs/%, $(T_PRG_SRC))

C_PRG_SRC := $(wildcard programs/computer/*.lua)
C_PRG_DST := $(patsubst programs/computer/%.lua, computer/progs/%, $(C_PRG_SRC))

all : turtle_build computer_build

turtle_build : turtle $(T_API_DST) $(T_PRG_DST)
	@cp startups/startup-turtle.lua turtle/startup
	@echo Compiled turtle bundle

turtle :
	@mkdir turtle
	@mkdir turtle/apis turtle/progs

turtle/apis/% : apis/turtle/%.lua
	@cp $< $@

turtle/progs/% : programs/turtle/%.lua
	@cp $< $@

computer_build : computer $(C_API_DST) $(C_PRG_DST)
	@cp startups/startup-computer.lua computer/startup
	@echo Compiled computer bundle

computer :
	@mkdir computer
	@mkdir computer/apis computer/progs

computer/apis/% : apis/computer/%.lua
	@cp $< $@

computer/progs/% : programs/computer/%.lua
	@cp $< $@

