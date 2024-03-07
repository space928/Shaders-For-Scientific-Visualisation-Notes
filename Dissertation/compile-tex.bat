echo Compiling dissertation
rem To compile BibTex correctly you need to run pdflatex once before and twice after bibtex. Seems like a bodge to me...
pdflatex l4proj -quiet
bibtex l4proj
pdflatex l4proj -quiet
pdflatex l4proj -quiet
