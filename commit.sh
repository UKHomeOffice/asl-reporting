#! /bin/bash
git add *.md *.png *.svg *.dat *.gnu *.jpg *.sh *.txt *.pl
git commit -m "Add files required for weekly report. ${@}"
git push
