APOLLO_GCC=ApolloCrossDev
APOLLO_DEVPAC=ApolloDevPac

C_COMPILER=$(APOLLO_GCC)/bin/vc
S_COMPILER=$(APOLLO_GCC)/bin/vasmm68k_mot
O_LINKER=$(APOLLO_GCC)/bin/vlink

S_INCLUDE=$(APOLLO_DEVPAC)/Include
C_INCLUDE= $(APOLLO_GCC)/bin/targets/m68k-amigaos/include
C_INCLUDE_NDK32=$(APOLLO_GCC)/ndk/NDK3.2/Include_H
C_INCLUDE_NDK39=$(APOLLO_GCC)/ndk/NDK3.9/Include/include_h

C_LIBS= $(APOLLO_GCC)/bin/targets/m68k-amigaos/lib
C_LIBS_NDK32=$(APOLLO_GCC)/ndk/NDK3.2/lib
C_LIBS_NDK39=$(APOLLO_GCC)/ndk/NDK3.9/Include/linker_libs

C_FLAGS= +aos68k -I$(C_INCLUDE) -I$(C_INCLUDE_NDK39) -o
O_FLAGS= -bamigahunk -x -Bstatic -Cvbcc -nostdlib -mrel -L$(C_LIBS) -L$(C_LIBS_NDK39) -lvc -o 
#O_FLAGS= -bamigahunk -x -Bstatic -Cvbcc -nostdlib -mrel $(C_LIBS)/startup.o -L$(C_LIBS) -L$(C_LIBS_NDK39) -lvc -o 
S_FLAGS= -quiet -m68080 -Fhunk -linedebug -o

C_SOURCEDIR=C-Source
S_SOURCEDIR=S-Source

C_OBJECTDIR=C-Build
S_OBJECTDIR=S-Build

C_FILES=$(wildcard $(C_SOURCEDIR)/*.c)
S_FILES=$(wildcard $(S_SOURCEDIR)/*.s)
O_FILES=$(patsubst $(C_SOURCEDIR)/%.c,$(C_OBJECTDIR)/%.o,$(C_FILES)) $(patsubst $(S_SOURCEDIR)/%.s,$(S_OBJECTDIR)/%.o,$(S_FILES))

EXE=Output

RM:=rm -f 
PATHSEP:=/

$(info  )
$(info ########################################)
$(info #  ApolloCrossDev VBCC Edition v0.1    #)
$(info ########################################)
$(info  )
$(info $(O_FILES) $(C_FILES))
$(info  )

all: $(EXE)

#$(EXE) : $(C_FILES)
#	$(C_COMPILER) $(C_FLAGS) $@ $< 

$(EXE) : $(O_FILES) 
	$(O_LINKER) $(O_FLAGS) $(EXE) $(O_FILES)

$(C_OBJECTDIR)/%.o : $(C_SOURCEDIR)/%.c
	$(C_COMPILER) $(C_FLAGS) $@ $< 

$(S_OBJECTDIR)/%.o : $(S_SOURCEDIR)/%.s
	$(S_COMPILER) $(S_FLAGS) $@ $<

clean:
	-$(RM) $(C_OBJECTDIR)$(PATHSEP)*.o
	-$(RM) $(S_OBJECTDIR)$(PATHSEP)*.o
	-$(RM) $(subst /,$(PATHSEP),$(EXE))

