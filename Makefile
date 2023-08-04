build:
	flex -o a.c mylex.lex;
	gcc -o arun a.c;

clean:
	rm arun a.c;

run:
	./arun input.txt;