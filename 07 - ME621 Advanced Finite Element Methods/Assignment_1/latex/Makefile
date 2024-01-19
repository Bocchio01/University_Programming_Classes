.PHONY: assignment_1 clean

CC = xelatex

all: assignment_1 clean

assignment_1: Assignment_1.tex
	$(CC) $<

clean:
	del /Q *.aux
	del /Q *.lof
	del /Q *.log
	del /Q *.lot
	del /Q *.out
	del /Q *.toc
	del /Q *.fdb_latexmk
	del /Q *.fls
	del /Q *.gz