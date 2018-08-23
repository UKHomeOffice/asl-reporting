#! /bin/bash
git add *.md *.png *.svg *.dat *.gnu *.jpg *.sh *.txt *.pl
git add graphs/*.png graphs/*.svg graphs/*.dat graphs/*.txt graphs/*.jpg graphs/*.gnu
git commit -m "Add files required for weekly report. ${@}"
git push
