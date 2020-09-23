EXE = c-asm
AS = gcc -m32
FLAGS = -c
OBJ = parking.o parking_asm.o

all: $(OBJ) 
	$(AS) -o $(EXE) $(OBJ) 
	
parking.o: parking.c 
	$(AS) $(FLAGS) -o parking.o parking.c 
	
parking_asm.o: parking_asm.s 
	$(AS) $(FLAGS) -o parking_asm.o parking_asm.s 
	
clean: 
	rm -f *.o $(EXE) core
