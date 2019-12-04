#!/bin/bash
CURRENT=`pwd`
cd /home/mark/projects/scrsht
node index.js  "$@"
cd ${CURRENT}
cp /home/mark/projects/scrsht/screenshots/url.png graphs

