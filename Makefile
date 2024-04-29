all: clean
	@flex -o simple-flex-code.c simple-flex-code.l
	@gcc -o simple-flex-code simple-flex-code.c
	@./simple-flex-code input.txt output.txt
clean:
	@if [ -e "simple-flex-code" ]; then rm simple-flex-code; fi
	@if [ -e "simple-flex-code.c" ]; then rm simple-flex-code.c; fi
