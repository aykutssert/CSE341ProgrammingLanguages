

run: 
	yacc -d -o gpp_interpreter.c gpp_interpreter.y
	flex -o gpp_lexer.c gpp_lexer.l 
	gcc gpp_lexer.c gpp_interpreter.c  -o main -ll -w
	./main

input:
	./main input.gpp

output:
	./main input.gpp > output.txt