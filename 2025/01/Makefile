main.out: main.o
	ld main.o -o main.out

main.o:	main.asm
	nasm -felf64 main.asm -o main.o

run: main.out
	./main.out
