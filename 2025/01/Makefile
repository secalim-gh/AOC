main.out: main.o
	ld main.o -o main.out

main.o:	main.asm
	nasm -felf64 main.asm -o main.o

run: main.out
	./main.out

main2.out: main2.o
	ld main2.o -o main2.out

main2.o:	main2.asm
	nasm -felf64 main2.asm -o main2.o

run2: main2.out
	./main2.out

all : main.out main2.out 
.PHONY : all
