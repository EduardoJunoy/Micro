all: P4A2.com P4B2.exe

P4A2.com: P4A2.obj
	tlink /v /t P4A2.obj
	
P4A2.obj: P4A2.asm
	tasm /zi P4A2.asm
	
P4B2.exe: P4B2.obj
	tlink /v P4B2.objs
	
P4B2.obj: P4B2.asm
	tasm /zi P4B2.asm