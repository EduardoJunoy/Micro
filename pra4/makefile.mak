all: apuntes4.exe

apuntes4.exe: apuntes4.obj
	tlink /v apuntes4
apuntes4.obj: apuntes4.asm
 	tasm /zi apuntes4.asm,,apuntes4.lst
del: 
	del apuntes4.exe
	del apuntes4.lst
	del apuntes4.obj
	del apuntes4.map