all: p1.com p2.exe

p1.com: p1.obj
	tlink /v /t p1.obj
	
p1.obj: p1.asm
	tasm /zi p1.asm
	
p2.exe: p2.obj
	tlink /v p2.objs
	
p2.obj: p2.asm
	tasm /zi p2.asm