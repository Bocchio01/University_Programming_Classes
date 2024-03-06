.PHONY: proposal Motivations ppt clean

all: Motivations clean

CC = xelatex

proposal: 01_Proposal/Proposal.tex
	$(eval DIR := 01_Proposal)
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<

Motivations: 02_Motivations/Motivations.tex
	$(eval DIR := 02_Motivations)
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<

ppt: Presentation/Presentation.tex
	$(eval DIR := Presentation)
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<


clean:
	del /Q $(DIR)\*.aux
	del /Q $(DIR)\*.lof
	del /Q $(DIR)\*.log
	del /Q $(DIR)\*.lot
	del /Q $(DIR)\*.out
	del /Q $(DIR)\*.toc
	del /Q $(DIR)\*.fdb_latexmk
	del /Q $(DIR)\*.fls
	del /Q $(DIR)\*.gz
	del /Q $(DIR)\*.ist
	del /Q $(DIR)\*.glo
	del /Q $(DIR)\*.bbl
	del /Q $(DIR)\*.acn