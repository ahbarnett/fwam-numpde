# fwam-numpde

numerical function approximation and PDE lecture notes for FWAM 2019 conference

Authors: Alex Barnett and Keaton Burns

### To build

```sudo apt install texlive-science texlive-latex-extra
```

```pdflatex -shell-escape numpde; bibtex numpde; pdflatex numpde; pdflatex numpde
```

```evince numpde.pdf
```
