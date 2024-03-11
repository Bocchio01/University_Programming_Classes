.PHONY: all Proposal Motivations PPT_Motivations PPT_Working_principles PPT_Technology_comparison_Applications PPT_Future_Directions Final_report

all: Proposal Motivations PPT_Motivations PPT_Working_principles PPT_Technology_comparison_Applications PPT_Future_Directions Final_report

CC = xelatex

Proposal: 01_Proposal/Proposal.tex
	$(eval DIR := 01_Proposal)
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<

Motivations: 02_Motivations/Motivations.tex
	$(eval DIR := 02_Motivations)
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<

PPT_Motivations: 03_01_Motivations/Motivations.tex
	$(eval DIR := 03_01_Motivations)
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<

PPT_Working_principles: 03_02_Working_principles/Working_principles.tex
	$(eval DIR := 03_02_Working_principles)
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<

PPT_Technology_comparison_Applications: 03_03_Technology_comparison_Applications/Technology_comparison_Applications.tex
	$(eval DIR := 03_03_Technology_comparison_Applications)
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<

PPT_Future_Directions: 03_04_Future_Directions/Future_directions.tex
	$(eval DIR := 03_04_Future_Directions)
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<

Final_report: 04_Final_report/Final_report.tex
	$(eval DIR := 04_Final_report)
	$(CC) -output-directory=$(DIR) -include-directory=$(DIR)/ $<
