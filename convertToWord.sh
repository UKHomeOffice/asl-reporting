#! /bin/bash
## pandoc --data-dir='~/projects/cv' --verbose CV.md -o CV.docx
pandoc --reference-doc default.docx -o ${@}.docx ${@}.md

