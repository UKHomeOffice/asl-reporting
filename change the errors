#! /bin/bash
if [ $# -eq 0 ]; then
    echo "No commit comment provided - giving up"
    exit 1
fi

git add *.md *.png *.svg *.dat *.gnu *.jpg *.sh *.txt 
git add graphs/*.png graphs/*.svg graphs/*.dat graphs/*.txt graphs/*.jpg graphs/*.gnu
git commit -m "Add files required for weekly report. ${@}"
git push
